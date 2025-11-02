from dotenv import load_dotenv
load_dotenv()

import streamlit as st
import os
import psycopg2
import pandas as pd
from datetime import datetime
from typing import Dict, Tuple, List
from agent import agent, store_verified_query
from db_schema import schema
from utils.gspread_client import init_gspread_client, log_query_to_sheet, fetch_approved_queries


def get_db_connection():
    """Establishes and returns a connection to the PostgreSQL database."""
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        database=os.getenv("DB_NAME", "postgres"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", "lucky535")
    )

def authenticate_user(user_id):
    """Authenticate user from database and retrieve role and school_id."""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT id, username, role, school_id FROM users WHERE id = %s", (user_id,))
        user = cur.fetchone()
        cur.close()
        conn.close()
        
        if user:
            school_id = user[3]
            if school_id is None and user[2].upper() != 'ADMIN':
                st.error(f"User {user_id} found, but is not assigned a school_id. Access denied.")
                return None
            
            return {
                'user_id': user[0],
                'username': user[1], 
                'role': user[2].upper(), 
                'school_id': school_id 
            }
        return None
    except Exception as e:
        st.error(f"Authentication error: {e}")
        return None

def log_query(user_id, role, query):
    """Log queries for audit purposes"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO query_log (user_id, role, query_text, timestamp) 
            VALUES (%s, %s, %s, %s)
        """, (user_id, role, query, datetime.now()))
        conn.commit()
        cur.close()
        conn.close()
    except:
        pass  # Ignore logging errors

def add_access_control(sql: str, user_info: Dict) -> str:
    """Add role-based and school-level access control to SQL queries (Unchanged from prototype.py)."""
    sql_lower = sql.lower().strip()
    role = user_info['role']
    user_id = user_info['user_id']
    school_id = user_info['school_id'] 

    if role == 'ADMIN':
        return sql
    
    if school_id is None:
        raise ValueError("Cannot execute query: User is not assigned a valid school_id.")
    
    def add_restriction(original_sql, restriction):
        if ' where ' in original_sql.lower():
            return original_sql + f" AND {restriction}"
        else:
            sql_lower_safe = original_sql.lower().strip()
            keywords_to_check = ['order by', 'group by', 'limit', ';']
            insertion_point = len(original_sql)
            
            for keyword in keywords_to_check:
                index = sql_lower_safe.find(keyword)
                if index != -1 and index < insertion_point:
                    insertion_point = index
            
            insert_clause = f" WHERE {restriction}"
            return original_sql[:insertion_point] + insert_clause + original_sql[insertion_point:]

    if 'school_id' not in sql_lower:
        sql = add_restriction(sql, f"school_id = {school_id}")

    if role == 'STUDENT':
        personal_tables = ['student', 'exam_result', 'attendance_log', 'student_leaves']
        for table in personal_tables:
            if table in sql_lower:
                if 'student_id' not in sql_lower and 'user_id' not in sql_lower:
                    if table == 'student' or table == 'users':
                        sql = add_restriction(sql, f"user_id = {user_id}")
                    else:
                        sql = add_restriction(sql, f"student_id = {user_id}")
                break
    
    elif role == 'TEACHER':
        if 'student' in sql_lower and 'class_id' not in sql_lower:
            sql = add_restriction(sql, f"class_id IN (SELECT id FROM classroom WHERE class_teacher_id = {user_id})")

    return sql

def read_postgres_query(sql: str, user_info: Dict) -> Tuple[List, List]:
    """Executes the SQL query on the database."""
    try:
        sql_controlled = add_access_control(sql, user_info)
        
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(sql_controlled)
        
        rows = cur.fetchall()
        colnames = [desc[0] for desc in cur.description]
        
        conn.commit()
        cur.close()
        conn.close()
        
        log_query(user_info['user_id'], user_info['role'], sql_controlled)
        
        st.session_state['last_successful_sql'] = sql
        
        return rows, colnames
        
    except Exception as e:
        st.error(f"Database/Access Error: {e}")
        st.session_state['last_successful_sql'] = None
        return [], []

def get_role_based_prompt(role, school_id, user_id):
    """Generate role-specific schema prompt (Unchanged from prototype.py)."""
    # NOTE: The LLM Agent will prepend RAG context to this schema prompt
    base_prompt = f"""
You are an expert in converting English questions to PostgreSQL queries for a school management system.

***MANDATORY SECURITY RULE FOR {role}***:
- FOR ALL QUERIES, YOU MUST include the condition `school_id = {school_id}` in the WHERE clause for tables that have it. 
- If the question does not explicitly mention school_id, you must still include the filter `school_id = {school_id}`.
- User ID: {user_id}, Role: {role}

KEY TABLES AND COLUMNS(data types and meaning of tghe columns are known to you):
{schema}

ROLE-SPECIFIC RULES:
"""
    
    if role == 'STUDENT':
        base_prompt += f"""
- You can only access YOUR OWN student data (user_id = {user_id})
- For personal data queries, always include student_id = {user_id} or user_id = {user_id}
"""
    elif role == 'TEACHER':
        base_prompt += f"""
- You can access your profile and your assigned classes' data
- You can see students in your classes. For student queries, you must filter by classes you teach: class_id IN (SELECT id FROM classroom WHERE class_teacher_id = {user_id})
"""
    elif role == 'PRINCIPAL':
        base_prompt += f"""
- You can access all data within your school (school_id = {school_id})
"""
    elif role == 'ADMIN':
        base_prompt += """
- You have access to all schools and data
"""
    
    base_prompt += """

IMPORTANT RULES:
1. Use PostgreSQL syntax 
2. Table names are in lowercase
3. Use proper JOIN syntax when querying multiple tables
4. For user roles: 'STUDENT', 'TEACHER', 'PRINCIPAL', 'ADMIN'
5. For leave status: 'PENDING', 'APPROVED', 'REJECTED'
6. For attendance status: true (present), false (absent)
7. Days in timetable: 'MONDAY', 'TUESDAY', etc.
8. Return only the SQL query without ``` or explanations
9. The Python execution layer will enforce final access control, but your query must adhere to the schema and general rules.

EXAMPLES:
Q: How many students are there?
A: SELECT COUNT(*) FROM student WHERE school_id = """ + str(school_id) + """;

Q: Show my exam results
A: SELECT e.name, s.name as subject, er.marks_obtained, er.total_marks FROM exam_result er JOIN exam e ON er.exam_id = e.id JOIN subject s ON er.subject_id = s.id WHERE er.student_id = """ + str(user_id) + """ AND er.school_id = """ + str(school_id) + """;
"""
    
    return base_prompt

def get_role_based_examples(role):
    """Return role-specific example questions"""
    examples = {
        'STUDENT': [
            "Show my exam results",
            "What's my attendance this month?",
            "Do I have any pending leave requests?",
            "What events are coming up?",
            "Show my class timetable"
        ],
        'TEACHER': [
            "How many students are in my classes?",
            "Show attendance for my class today",
            "Which students have low marks in my subject?",
            "What's my teaching schedule this week?",
            "Show pending leave requests from my students"
        ],
        'PRINCIPAL': [
            "How many students are enrolled in our school?",
            "Show all teachers in the school",
            "Which classes have the best exam performance?",
            "What events are scheduled this month?",
            "Show overall attendance statistics"
        ],
        'ADMIN': [
            "Show statistics across all schools",
            "Which schools have the most students?",
            "Show system-wide user activity",
            "Display performance metrics by school"
        ]
    }
    return examples.get(role, [])


# --- NEW: Function to sync approved queries from Google Sheets ---
@st.cache_data(ttl=600) # Cache for 10 mins to avoid hitting GSheet API too often
def sync_vector_db(_sheet):
    """
    Fetches approved queries from Google Sheets and stores them
    in the in-memory Vector DB (VERIFIED_QUERIES in agent.py).
    
    The _sheet parameter is used to bust the cache when we force-sync.
    """
    print("Syncing approved queries from Google Sheets...")
    approved_df = fetch_approved_queries(_sheet)
    new_queries_added = 0
    
    if approved_df.empty:
        print("No new approved queries found.")
        return 0
        
    for _, row in approved_df.iterrows():
        try:
            # Ensure data types are correct for storage
            user_id = int(row['user_id'])
            role = str(row['role'])
            question = str(row['user_question'])
            sql = str(row['generated_sql'])
            
            # store_verified_query now handles duplicate prevention
            if store_verified_query(question, sql, user_id, role):
                new_queries_added += 1
        except Exception as e:
            print(f"Skipping row due to error: {e}. Row: {row}")
            
    print(f"Synced {new_queries_added} new queries.")
    return new_queries_added


# Streamlit App Configuration
st.set_page_config(
    page_title="School Database Query Assistant", 
    page_icon="🏫",
    layout="wide"
)

# Initialize session state for the verification loop
if 'authenticated' not in st.session_state:
    st.session_state.authenticated = False
    st.session_state.user_info = None
if 'last_question' not in st.session_state:
    st.session_state.last_question = None
if 'last_successful_sql' not in st.session_state:
    st.session_state.last_successful_sql = None
if 'generation_details' not in st.session_state:
    st.session_state.generation_details = []

# --- NEW: Initialize Google Sheets client once ---
if 'gspread_sheet' not in st.session_state:
    st.session_state.gspread_sheet = init_gspread_client()


# --- Authentication Block ---
if not st.session_state.authenticated:
    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        st.markdown("""
        <div style="text-align: center;">
            <h1>🏫 School Management System</h1>
            <h3>Database Query Assistant</h3>
            <hr>
        </div>
        """, unsafe_allow_html=True)
        st.markdown("### 🔑 Authentication Required")
        
        if not st.session_state.gspread_sheet:
            st.error("🔴 **Critical Error:** Failed to connect to Google Sheets. The review system is offline. Please check service account credentials.")
        else:
            st.warning("⚠️ **Access Control**: Please authenticate to access the database query system.")
        
        with st.form("user_login_form", clear_on_submit=False):
            user_id = st.number_input(
                "User ID:", 
                min_value=1, 
                step=1, 
                value=1,
                help="Enter your unique user ID from the database"
            )
            login_button = st.form_submit_button("🔑 Authenticate", type="primary", use_container_width=True, disabled=(not st.session_state.gspread_sheet))
            
            if login_button:
                with st.spinner("⏳ Verifying credentials..."):
                    user_info = authenticate_user(user_id)
                    
                    if user_info:
                        if user_info['school_id'] is not None or user_info['role'] == 'ADMIN':
                            st.session_state.authenticated = True
                            st.session_state.user_info = user_info
                            
                            # --- NEW: Sync Vector DB on Login ---
                            with st.spinner("Syncing verified query cache..."):
                                count = sync_vector_db(st.session_state.gspread_sheet)
                                st.success(f"Synced {count} verified queries.")
                                
                            st.success(f"✅ Welcome {user_info['username']} ({user_info['role']})!")
                            st.balloons()
                            st.rerun()
                    else:
                        st.error("❌ Authentication failed. Invalid User ID or missing school ID.")

else:
    # === AUTHENTICATED USER - MAIN APPLICATION ===
    user_info = st.session_state.user_info
    
    # Header
    col1, col2, col3 = st.columns([3, 2, 1])
    with col1: st.header("🏫 School Database Query Assistant")
    with col2:
        st.info(f"""
        **👤 {user_info['username']}** | **{user_info['role']}** School ID: {user_info['school_id']}
        """)
    with col3:
        if st.button("🚪 Logout", type="secondary"):
            st.session_state.authenticated = False
            st.session_state.user_info = None
            st.session_state.last_question = None
            st.session_state.last_successful_sql = None
            st.session_state.generation_details = []
            st.success("Logged out successfully!")
            st.rerun()
    
    st.markdown("---")
    
    examples = get_role_based_examples(user_info['role'])
    
    # Main interface 
    col_main, col_sidebar = st.columns([2, 1])
    
    with col_main:
        st.markdown(f"### 💬 Ask Questions About Your School Database")
        
        st.markdown("**Example queries:**")
        for i, example in enumerate(examples[:3], 1):
            st.markdown(f"• *{example}*")
        
        question = st.text_area(
            "✍️ Enter your question:", 
            height=100,
            placeholder=examples[0] if examples else "Ask about your school data...",
            key='query_input',
            help="Ask questions in plain English - AI will generate SQL automatically"
        )
        
        # Submit button
        if st.button("🔍 Get Answer", type="primary", use_container_width=True):
            if question.strip():
                # Reset previous successful query state
                st.session_state.last_successful_sql = None 
                st.session_state.last_question = question
                st.session_state.generation_details = []
                
                with st.spinner("🤖 Processing Text-to-SQL (RAG, Generation, Syntax Check/Retry)..."):
                    try:
                        if user_info['school_id'] is None and user_info['role'] != 'ADMIN':
                            st.error("Security Error: Cannot generate query because your user account is missing a school ID.")
                            st.stop()
                            
                        # 1. Get Base Schema/Context
                        schema_prompt = get_role_based_prompt(
                            user_info['role'], 
                            user_info['school_id'], 
                            user_info['user_id']
                        )
                        
                        # 2. Process Question (RAG, LLM, Syntax Check/Retry Loop)
                        sql_query, details = agent.process_question(
                            question, 
                            schema_prompt, 
                            user_info
                        )
                        st.session_state.generation_details = details
                        
                        st.markdown("### 📊 Generated SQL Query:")
                        st.code(sql_query, language="sql")
                        
                        # --- NEW: Log query to Google Sheets ---
                        try:
                            log_query_to_sheet(
                                st.session_state.gspread_sheet, 
                                user_info, 
                                question, 
                                sql_query
                            )
                            st.info("Query logged to Google Sheets for review.")
                        except Exception as e:
                            st.warning(f"Could not log query to Google Sheets: {e}")
                        
                        # 3. Execute the query
                        with st.spinner("⚡ Executing query on SQL DB..."):
                            rows, colnames = read_postgres_query(sql_query, user_info)
                            
                            if rows:
                                st.markdown("### 📋 Results:")
                                if colnames:
                                    df = pd.DataFrame(rows, columns=colnames)
                                    st.dataframe(df, use_container_width=True)
                                    
                                    csv = df.to_csv(index=False)
                                    st.download_button(
                                        label="💾 Download CSV",
                                        data=csv,
                                        file_name=f"query_results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                                        mime="text/csv"
                                    )
                                st.success(f"✅ Found {len(rows)} result(s). The query was successful.")
                            else:
                                if st.session_state.last_successful_sql is not None:
                                    st.info("ℹ️ Query executed successfully but returned no results. Check your filters.")
                                # If last_successful_sql is None, the error message from read_postgres_query was already shown.

                    except Exception as e:
                        st.error(f"❌ An internal error occurred during processing: {str(e)}")
            else:
                st.warning("⚠️ Please enter a question first!")

        # --- REMOVED: Manual Verification Loop UI ---
        # The old verification button is gone, as this is now
        # handled offline in Google Sheets.
            
        # --- Debug/Details Sidebar ---
        with st.expander("🤖 LLM Generation & RAG Details"):
            if st.session_state.generation_details:
                for detail in st.session_state.generation_details:
                    st.code(detail)
            else:
                st.info("Details of the LLM RAG and Correction attempts will appear here after execution.")
    
    with col_sidebar:
        # User access level
        st.markdown("### 🔒 Access Level")
        access_color = {
            'ADMIN': '🟢',
            'PRINCIPAL': '🟡', 
            'TEACHER': '🔵',
            'STUDENT': '🔴'
        }
        st.markdown(f"{access_color.get(user_info['role'], '⚪')} **{user_info['role']}**")
        
        # --- NEW: Admin Tools ---
        if user_info['role'] == 'ADMIN':
            st.markdown("### ⚙️ Admin Tools")
            st.warning("You are an Admin. You can force a re-sync of the approved queries from Google Sheets.")
            if st.button("🔄 Sync Approved Queries"):
                with st.spinner("Forcing sync of approved queries..."):
                    # Bust the cache by passing a new value
                    count = sync_vector_db(datetime.now()) 
                    st.success(f"✅ Synced {count} new verified queries.")
                    st.rerun()

        # Available tables
        st.markdown("### 📚 Available Data")
        st.markdown("""
        **Core Tables:**
        - Users, School
        - Classrooms, Subjects
        - **Student** & **Teacher** Data
        - **Exam** & **Results**
        - **Attendance** & **Leaves**
        - Timetables, Events, Holidays
        """)
        
        # Quick tips
        st.markdown("### 💡 Agent Architecture")
        st.markdown("""
        The system now follows the new RAG workflow:
        1. **Log:** All generated queries are logged to Google Sheets.
        2. **Verify (Offline):** An admin reviews queries in the Sheet and marks `approved` as `TRUE`.
        3. **Sync:** On login (or manual sync), the app fetches all approved queries.
        4. **Store:** Approved queries are embedded and stored in the Vector DB, prioritized by user.
        5. **Retrieve:** When you ask a question, the LLM retrieves relevant *personalized* examples from the Vector DB to improve its accuracy.
        """)