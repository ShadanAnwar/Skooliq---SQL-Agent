from dotenv import load_dotenv
load_dotenv()

import streamlit as st
import os
import psycopg2
import google.generativeai as genai
import pandas as pd
from datetime import datetime

# Configure Gemini API
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

def get_gemini_response(question, prompt):
    model = genai.GenerativeModel('gemini-2.5-flash')
    response = model.generate_content([prompt, question])
    return response.text

def get_db_connection():
    # Use environment variables for production, but using your provided defaults for immediate testing
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
        # Retrieve school_id as well
        cur.execute("SELECT id, username, role, school_id FROM users WHERE id = %s", (user_id,))
        user = cur.fetchone()
        cur.close()
        conn.close()
        
        if user:
            # IMPORTANT: Ensure school_id is converted to int/str or handled if None
            school_id = user[3]
            if school_id is None:
                st.error(f"User {user_id} found, but is not assigned a school_id in the database. Access denied.")
                return None

            return {
                'user_id': user[0],
                'username': user[1], 
                'role': user[2].upper(), 
                'school_id': school_id # Pass the retrieved ID
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

def add_access_control(sql, user_info):
    """
    Add role-based and school-level access control to SQL queries.
    
    CRITICAL FIX: Ensure user_info['school_id'] is a valid, non-None value
    before attempting to use it in the SQL string.
    """
    sql_lower = sql.lower().strip()
    role = user_info['role']
    user_id = user_info['user_id']
    school_id = user_info['school_id'] # This is now guaranteed to be non-None if auth passed

    # Admin bypasses all checks
    if role == 'ADMIN':
        return sql
    
    # Check for empty school_id which should have been caught in auth, but for safety
    if school_id is None:
        raise ValueError("Cannot execute query: User is not assigned a valid school_id.")
    
    # --- Helper function for adding restrictions (handles WHERE vs AND) ---
    def add_restriction(original_sql, restriction):
        """Intelligently adds WHERE or AND to the SQL query."""
        
        # 1. Check for existing WHERE clause
        if ' where ' in original_sql.lower():
            return original_sql + f" AND {restriction}"
        else:
            # 2. If no WHERE, find the safest place to insert 'WHERE' 
            sql_lower_safe = original_sql.lower().strip()
            keywords_to_check = ['order by', 'group by', 'limit', ';']
            insertion_point = len(original_sql)
            
            for keyword in keywords_to_check:
                index = sql_lower_safe.find(keyword)
                if index != -1 and index < insertion_point:
                    insertion_point = index
            
            insert_clause = f" WHERE {restriction}"
            return original_sql[:insertion_point] + insert_clause + original_sql[insertion_point:]

    # 1. Mandatory School ID Restriction (for non-admin users)
    # This filter MUST be applied, regardless of what the LLM generated.
    # We check if a school_id filter is already present to avoid redundancy, 
    # but the enforcement logic guarantees it is added if needed.
    if 'school_id' not in sql_lower:
        sql = add_restriction(sql, f"school_id = {school_id}")

    # 2. Role-specific restrictions (applied after school_id)
    
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

def read_postgres_query(sql, user_info):
    try:
        # Add access control to SQL query, this function will now explicitly raise 
        # an error if school_id is missing, preventing "None" in the query.
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
        
        return rows, colnames
        
    except Exception as e:
        st.error(f"Database/Access Error: {e}")
        return [], []

def get_role_based_prompt(role, school_id, user_id):
    """
    Generate role-specific schema prompt.
    CRITICAL PROMPT CHANGE: Strongly emphasize that school_id must be included.
    """
    base_prompt = f"""
You are an expert in converting English questions to PostgreSQL queries for a school management system.

***MANDATORY SECURITY RULE FOR {role}***:
- FOR ALL QUERIES, YOU MUST include the condition `school_id = {school_id}` in the WHERE clause, unless the table doesn't have a school_id column (like USERS, where you should use the JOIN condition). 
- If the question does not explicitly mention school_id, you must still include the filter `school_id = {school_id}`.
- User ID: {user_id}, Role: {role}

KEY TABLES AND COLUMNS:
... (Table structure remains the same)
"""
    
    # ... (Rest of the prompt definition, unchanged for brevity)
    base_prompt = f"""
You are an expert in converting English questions to PostgreSQL queries for a school management system.

***MANDATORY SECURITY RULE FOR {role}***:
- FOR ALL QUERIES, YOU MUST include the condition `school_id = {school_id}` in the WHERE clause for tables that have it. 
- If the question does not explicitly mention school_id, you must still include the filter `school_id = {school_id}`.
- User ID: {user_id}, Role: {role}

KEY TABLES AND COLUMNS:

USERS: id, username, role, school_id
SCHOOL: id, name, address, city, state, contact_email, contact_number
ACADEMIC_YEAR: id, value, start_date, end_date, is_active
CLASSROOM: id, class_name, class_teacher_id, school_id, academic_year_id
STUDENT: id, user_id, school_id, first_name, last_name, date_of_birth, gender, class_id, roll_number, email, mobile_number, total_points, total_questions_solved
TEACHER: id, user_id, school_id, first_name, last_name, email, mobile_number, joining_date, academic_year_id
PRINCIPAL: id, user_id, school_id, first_name, last_name, email, mobile_number, joining_date, academic_year_id
SUBJECT: id, name, class_id, school_id, academic_year_id
EXAM: id, name, class_id, school_id, start_date, end_date, academic_year_id
EXAM_RESULT: id, exam_id, student_id, subject_id, marks_obtained, total_marks, grade, remarks
ATTENDANCE_LOG: id, student_id, class_id, date, status
STUDENT_LEAVES: leave_id, student_id, start_date, end_date, description, status, leave_type_id, school_id
TEACHER_LEAVES: leave_id, teacher_id, start_date, end_date, description, status, leave_type_id, school_id
TIMETABLE: id, day, time_from, time_to, class_id, subject_id, teacher_id, academic_year_id
EVENTS: id, school_id, event_name, description, event_date, event_start_time, event_end_time, created_by, academic_year_id
HOLIDAY: id, school_id, date, name, only_for_students, academic_year_id
NOTIFICATION: id, title, type_id, description, created_at, send_to, send_all, action_taken

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

# Streamlit App Configuration
st.set_page_config(
    page_title="School Database Query Assistant", 
    page_icon="🏫",
    layout="wide"
)

# Initialize session state
if 'authenticated' not in st.session_state:
    st.session_state.authenticated = False
    st.session_state.user_info = None

# === AUTHENTICATION REQUIRED ===
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
        
        st.markdown("### 🔐 Authentication Required")
        
        st.warning("⚠️ **Access Control**: Please authenticate to access the database query system.")
        
        # --- Simplified Login Form (Only User Login) ---
        st.markdown("**Enter your User ID to authenticate:**")
        
        with st.form("user_login_form", clear_on_submit=False):
            user_id = st.number_input(
                "User ID:", 
                min_value=1, 
                step=1, 
                value=1,
                help="Enter your unique user ID from the database"
            )
            
            login_button = st.form_submit_button("🔐 Authenticate", type="primary", use_container_width=True)
            
            if login_button:
                with st.spinner("🔍 Verifying credentials..."):
                    user_info = authenticate_user(user_id)
                    
                    if user_info:
                        # Ensure the school_id is valid before proceeding
                        if user_info['school_id'] is not None:
                            st.session_state.authenticated = True
                            st.session_state.user_info = user_info
                            st.success(f"✅ Welcome {user_info['username']} ({user_info['role']})!")
                            st.balloons()
                            st.rerun()
                        # If school_id was None, the authenticate_user function already showed an error
                    else:
                        st.error("❌ Authentication failed. Invalid User ID.")
        # --- End Simplified Login Form ---

        # Database status
        st.markdown("---")
        with st.expander("🔌 System Status"):
            try:
                conn = get_db_connection()
                conn.close()
                st.success("✅ Database connection available")
            except Exception as e:
                st.error(f"❌ Database connection failed: {str(e)}")

else:
    # === AUTHENTICATED USER - MAIN APPLICATION ===
    user_info = st.session_state.user_info
    
    # Header with user info and logout
    col1, col2, col3 = st.columns([3, 2, 1])
    
    with col1:
        st.header("🏫 School Database Query Assistant")
    
    with col2:
        st.info(f"""
        **👤 {user_info['username']}** | **{user_info['role']}**  
        School ID: {user_info['school_id']}
        """)
    
    with col3:
        if st.button("🚪 Logout", type="secondary"):
            st.session_state.authenticated = False
            st.session_state.user_info = None
            st.success("Logged out successfully!")
            st.rerun()
    
    st.markdown("---")
    
    examples = get_role_based_examples(user_info['role'])
    
    # Main interface (matches the image)
    col_main, col_sidebar = st.columns([2, 1])
    
    with col_main:
        st.markdown(f"### 💭 Ask Questions About Your School Database")
        
        st.markdown("**Example queries:**")
        for i, example in enumerate(examples[:3], 1):
            st.markdown(f"• *{example}*")
        
        # Query input
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
                with st.spinner("🤖 Generating SQL query..."):
                    try:
                        # Check one last time if school_id is valid before generating prompt
                        if user_info['school_id'] is None:
                            st.error("Security Error: Cannot generate query because your user account is missing a school ID.")
                            st.stop()
                            
                        schema_prompt = get_role_based_prompt(
                            user_info['role'], 
                            user_info['school_id'], 
                            user_info['user_id']
                        )
                        
                        sql_query = get_gemini_response(question, schema_prompt)
                        
                        # Clean up the response
                        sql_query = sql_query.strip()
                        if sql_query.startswith("```sql"):
                            sql_query = sql_query[6:].strip()
                        if sql_query.startswith("```"):
                            sql_query = sql_query[3:].strip()
                        if sql_query.endswith("```"):
                            sql_query = sql_query[:-3].strip()
                        
                        st.markdown("### 📝 Generated SQL Query:")
                        st.code(sql_query, language="sql")
                        
                        # Execute the query
                        with st.spinner("⚡ Executing query..."):
                            rows, colnames = read_postgres_query(sql_query, user_info)
                            
                            if rows:
                                st.markdown("### 📊 Results:")
                                
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
                                else:
                                    for i, row in enumerate(rows, 1):
                                        st.write(f"**Row {i}:** {row}")
                                
                                st.success(f"✅ Found {len(rows)} result(s)")
                            else:
                                st.info("ℹ️ Query executed successfully but returned no results. Check your filters.")
                                
                    except Exception as e:
                        st.error(f"❌ An internal error occurred during processing: {str(e)}")
            else:
                st.warning("⚠️ Please enter a question first!")
    
    with col_sidebar:
        # User access level
        st.markdown("### 🔒 Access Level")
        access_color = {
            'ADMIN': '🟢',
            'PRINCIPAL': '🟡', 
            'TEACHER': '🟠',
            'STUDENT': '🔴'
        }
        st.markdown(f"{access_color.get(user_info['role'], '⚪')} **{user_info['role']}**")
        
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
        
        # More examples
        if len(examples) > 3:
            st.markdown("### 💡 More Examples")
            for example in examples[3:]:
                st.markdown(f"• *{example}*")
        
        # Quick tips
        st.markdown("### 💡 Tips")
        st.markdown("""
        - Be specific about what data you need.
        - Use action words like **"Show," "Count," "List," "Find."**
        - Your results are **automatically filtered** based on your role and school.
        """)