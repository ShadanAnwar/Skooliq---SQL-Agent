import gspread
import pandas as pd
from google.oauth2.service_account import Credentials
from gspread_dataframe import get_as_dataframe, set_with_dataframe
from datetime import datetime
import uuid
from typing import Dict

# --- Config ---
# Ensure your service_account.json is in this 'utils' folder
SERVICE_ACCOUNT_FILE = "utils/service_account.json"  
SPREADSHEET_NAME = "queries_review"  
SHEET_NAME = "Sheet1"

# Define the expected columns
SHEET_COLUMNS = [
    "query_id", 
    "timestamp", 
    "user_id", 
    "role", 
    "user_question", 
    "generated_sql", 
    "approved"
]

def init_gspread_client():
    """
    Authenticates with Google and opens the specific worksheet.
    """
    try:
        scope = [
            "https://www.googleapis.com/auth/spreadsheets",
            "https://www.googleapis.com/auth/drive"
        ]
        creds = Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=scope)
        client = gspread.authorize(creds)
        sheet = client.open(SPREADSHEET_NAME).worksheet(SHEET_NAME)
        
        # Check for header and add if missing
        header = sheet.row_values(1)
        if header != SHEET_COLUMNS:
            # Clear and set header if sheet is empty or incorrect
            if not header or sheet.row_count == 1:
                sheet.clear()
                sheet.append_row(SHEET_COLUMNS)
                print("Google Sheet header initialized.")
            else:
                print(f"Warning: Sheet header {header} does not match expected {SHEET_COLUMNS}")

        return sheet
    except Exception as e:
        print(f"Failed to initialize Google Sheets client: {e}")
        return None

def log_query_to_sheet(sheet: gspread.Worksheet, user_info: Dict, question: str, sql_query: str):
    """
    Appends a new generated query to the Google Sheet for review.
    """
    if not sheet:
        print("GSpread sheet not initialized. Skipping log.")
        return

    try:
        new_row = [
            str(uuid.uuid4()),
            datetime.now().isoformat(),
            user_info['user_id'],
            user_info['role'],
            question,
            sql_query,
            False  # Default 'approved' to False
        ]
        sheet.append_row(new_row)
    except Exception as e:
        print(f"Error logging to Google Sheet: {e}")
        # Fallback to pandas (slower, but robust)
        try:
            new_data_df = pd.DataFrame([new_row], columns=SHEET_COLUMNS)
            existing_df = get_as_dataframe(sheet).dropna(how="all")
            updated_df = pd.concat([existing_df, new_data_df], ignore_index=True)
            set_with_dataframe(sheet, updated_df)
        except Exception as e2:
            print(f"Pandas fallback failed: {e2}")


def fetch_approved_queries(sheet: gspread.Worksheet) -> pd.DataFrame:
    """
    Fetches all rows from the Google Sheet that are marked as 'TRUE'
    in the 'approved' column.
    """
    if not sheet:
        return pd.DataFrame(columns=SHEET_COLUMNS)
        
    try:
        df = get_as_dataframe(sheet, use_header=True).dropna(how="all")
        
        if df.empty or 'approved' not in df.columns:
            return pd.DataFrame(columns=SHEET_COLUMNS)
        
        # Filter for approved rows. Handle 'TRUE' (str) or True (bool).
        approved_df = df[
            df['approved'].astype(str).str.upper() == 'TRUE'
        ]
        return approved_df
        
    except Exception as e:
        print(f"Error fetching approved queries: {e}")
        return pd.DataFrame(columns=SHEET_COLUMNS)