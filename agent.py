
import os
import re
import streamlit as st
import google.generativeai as genai
from typing import Dict, List, Tuple, Set
from sqlfluff.core import Linter # Requires 'sqlfluff' package installed

# --- Vector DB Simulation (In-Memory RAG) ---
# Stores a list of dictionaries: 
# [{'question': str, 'sql': str, 'embedding': List[float], 'user_id': int, 'role': str}]
VERIFIED_QUERIES: List[Dict] = []
# Set to track existing (question, sql) tuples to prevent duplicates
VERIFIED_QUERY_KEYS: Set[Tuple[str, str]] = set()
EMBEDDING_MODEL = 'models/text-embedding-004'

genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

def embed_text(text: str) -> List[float]:
    """Generates an embedding for the given text."""
    try:
        response = genai.embed_content(
            model=EMBEDDING_MODEL,
            content=text,
            task_type="RETRIEVAL_DOCUMENT"
        )
        return response['embedding']
    except Exception as e:
        print(f"Embedding error: {e}")
        return []

def cosine_similarity(vec_a: List[float], vec_b: List[float]) -> float:
    """Calculates cosine similarity between two vectors."""
    if not vec_a or not vec_b:
        return 0.0
    dot_product = sum(a * b for a, b in zip(vec_a, vec_b))
    magnitude_a = sum(a * a for a in vec_a) ** 0.5
    magnitude_b = sum(b * b for b in vec_b) ** 0.5
    
    if magnitude_a == 0 or magnitude_b == 0:
        return 0.0
        
    return dot_product / (magnitude_a * magnitude_b)

def retrieve_context(user_question: str, user_info: Dict) -> str:
    """
    Retrieves the most relevant past query and SQL from the Vector DB
    based on the user's question (RAG system).
    
    *** NEW: Now accepts user_info to personalize results. ***
    """
    if not VERIFIED_QUERIES:
        return ""
    
    # Embed the user question
    query_embedding = embed_text(user_question)
    if not query_embedding:
        return ""

    best_match = None
    max_similarity = -1

    # Find the nearest neighbor
    for record in VERIFIED_QUERIES:
        similarity = cosine_similarity(query_embedding, record['embedding'])
        
        # --- PERSONALIZATION BOOST ---
        boost = 1.0
        if record['user_id'] == user_info['user_id']:
            boost = 1.2  # 20% boost for user's own queries
        elif record['role'] == user_info['role']:
            boost = 1.1  # 10% boost for queries from the same role
            
        boosted_similarity = similarity * boost
        # --- End Boost ---
        
        if boosted_similarity > max_similarity:
            max_similarity = boosted_similarity
            best_match = record
            
    # Set a similarity threshold (e.g., 80%) to be considered relevant
    if max_similarity > 0.80 and best_match:
        similarity_score = max_similarity / boost # Report original similarity
        return (
            f"\n\n--- Relevant Past Query from Vector DB (Similarity: {similarity_score:.2f}) ---\n"
            f"Question: {best_match['question']}\n"
            f"SQL: {best_match['sql']}\n"
            f"--- End Context ---\n\n"
        )
    return ""

def store_verified_query(question: str, sql_query: str, user_id: int, role: str) -> bool:
    """
    Stores a manually verified question/SQL pair and its embedding into the 
    simulated Vector DB for future RAG retrieval.
    
    *** NEW: Now accepts user_id/role and prevents duplicates. ***
    """
    query_key = (question, sql_query)
    if query_key in VERIFIED_QUERY_KEYS:
        # This query is already in our in-memory DB
        return False
        
    combined_text = f"Question: {question}\nSQL: {sql_query}"
    embedding = embed_text(combined_text)
    
    if embedding:
        VERIFIED_QUERIES.append({
            'question': question, 
            'sql': sql_query, 
            'embedding': embedding,
            'user_id': user_id,
            'role': role
        })
        VERIFIED_QUERY_KEYS.add(query_key)
        print(f"Added query to Vector DB. Total queries: {len(VERIFIED_QUERIES)}")
        return True
    return False

# --- Syntax Checker (from sqlfluff_testing.py) ---
# (This section is unchanged)
def check_sql_syntax(sql: str, dialect: str = "postgres") -> bool:
    """
    Validate SQL syntax using sqlfluff.
    Returns True if syntax is correct (no parse errors/violations), otherwise False.
    Uses 'postgres' dialect as the database is PostgreSQL.
    """
    try:
        # We only care about parsing violations (syntax errors), not style/linting
        linter = Linter(dialect=dialect)
        parsed = linter.parse_string(sql)
        
        # Check if any violation is a PARSING/SYNTAX error (e.g., L001 is typically spacing)
        # We are only interested in fundamental parsing failure (V-level violations)
        # For simplicity in this demo, we check if there are any violations.
        return not parsed.violations
        
    except ImportError:
        print("SQLFluff not installed. Skipping rigorous syntax check.")
        # Fallback to a simpler, less reliable check to demonstrate the principle
        if re.match(r"^\s*(SELECT|INSERT|UPDATE|DELETE|WITH)\s", sql.strip().upper()):
             return True # Simple check for basic command start
        return False
    except Exception as e:
        print(f"Error during SQLFluff check: {e}")
        return False

# --- LLM Core Agent Logic ---
# (This section is mostly unchanged)
class LLMAgent:
    """
    Handles the LLM logic, including Text-to-SQL conversion, RAG integration,
    and the syntax checking/correction loop.
    """
    
    def __init__(self, model_name: str = 'gemini-2.5-flash'):
        self.model = genai.GenerativeModel(model_name)
        
    def generate_sql(self, full_prompt: str, user_question: str) -> str:
        """Calls the LLM to generate the SQL query."""
        response = self.model.generate_content([full_prompt, user_question])
        
        # Clean up the response
        sql_query = response.text.strip()
        sql_query = re.sub(r"```sql|```", "", sql_query, flags=re.IGNORECASE).strip()
        return sql_query

    def process_question(self, question: str, schema_prompt: str, user_info: Dict, max_retries: int = 2) -> Tuple[str, List[str]]:
        """
        Orchestrates the Text-to-SQL conversion with RAG and a syntax correction loop.
        
        *** NEW: Passes user_info to retrieve_context for personalization. ***
        """
        st.session_state['generation_details'] = []
        
        # 1. RAG Retrieval (Vector DB Interaction)
        # *** MODIFIED CALL ***
        retrieved_context = retrieve_context(question, user_info)
        
        # 2. Combine Schema, Docs (Implicit in schema_prompt), and RAG Context
        full_prompt = schema_prompt + retrieved_context
        
        # The prompt for the LLM to fix the query
        fix_prompt = (
            "The following SQL query you generated has a SYNTAX ERROR according to the PostgreSQL dialect. "
            "The error is likely due to incorrect usage of keywords, functions, or table/column names. "
            "Please carefully review the original question, the provided schema, and the erroneous query, and "
            "provide the corrected, executable SQL query ONLY. DO NOT INCLUDE ANY EXPLANATION."
        )
        
        final_query = ""
        generation_details = []
        
        for attempt in range(max_retries + 1):
            if attempt == 0:
                # First attempt: Generate SQL from scratch (with RAG context)
                sql_query = self.generate_sql(full_prompt, question)
                
                generation_details.append(f"Attempt 1: Initial generation using RAG context.")
                generation_details.append(f"Query: {sql_query}")
                
            else:
                # Subsequent attempts: Re-prompt the LLM to fix the previous failed query
                generation_details.append(f"Attempt {attempt + 1}: Retrying due to syntax error...")
                
                # Create a specific prompt to fix the failed query
                correction_prompt = f"{fix_prompt}\n\nFAILED QUERY: {sql_query}\n\nORIGINAL PROMPT/CONTEXT:\n{full_prompt}\n\nCORRECTED SQL:"
                
                sql_query = self.generate_sql(correction_prompt, question)
                
                generation_details.append(f"Query: {sql_query}")


            # 3. Syntax Checker
            if check_sql_syntax(sql_query):
                generation_details.append(f"Validation: ✅ Syntax OK.")
                final_query = sql_query
                break
            else:
                generation_details.append(f"Validation: ❌ Syntax Error detected. Retrying with LLM for correction.")
                # If this is the last attempt, break
                if attempt == max_retries:
                    generation_details.append("Max retries reached. Returning last generated query.")
                    final_query = sql_query # Return the last attempt even if it failed
                    
        return final_query, generation_details
        
agent = LLMAgent()