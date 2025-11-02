# 🏫 Secure Text-to-SQL RAG Agent with External Verification

> **A secure, human-in-the-loop Text-to-SQL system powered by Google Gemini and Google Sheets for transparent, verifiable AI query generation.**

---

## 🚀 Overview

This project implements a **secure, role-based Text-to-SQL agent** powered by **Google’s Gemini models**, augmented with a **Retrieval-Augmented Generation (RAG)** pipeline and **manual human verification via Google Sheets**.

It ensures that **only human-approved SQL queries** are used to train and improve the system — maintaining a transparent and trustworthy AI workflow.

---

## ✨ Key Features

### 🧠 LLM-Powered Text-to-SQL
Converts natural language questions into secure, executable **PostgreSQL** queries using **Gemini 2.5 Flash**.

### 🔐 Role-Based Access Control (RBAC)
Automatically applies contextual security filters (`school_id`, `user_id`, `class_id`) based on the logged-in user's role:
- `STUDENT`
- `TEACHER`
- `PRINCIPAL`
- `ADMIN`

### 🧾 Human-in-the-Loop Verification (Google Sheets)
- Every generated SQL query is **automatically logged** to a shared **Google Sheet**.  
- Queries must be **manually marked as `TRUE`** under the `approved` column before they are added to the RAG system.  
- Ensures the AI learns only from **verified, correct SQL statements**.

### 🧬 Personalized RAG System
- Stores verified SQL embeddings in an **in-memory vector database**.
- Retrieval is **boosted** for queries approved by the same user or role.
- Fast, accurate, and adaptive.

### 🛠️ Self-Correction Engine
Uses **sqlfluff** to validate and auto-correct SQL syntax before execution — reducing runtime errors and LLM noise.

---

## 🧩 Architecture Overview

| Component | Technology | Role |
|------------|-------------|------|
| **Frontend** | Streamlit (`app.py`) | User interface, authentication, and query execution |
| **LLM Agent** | Gemini 2.5 Flash (`agent.py`) | Text-to-SQL generation + correction loop |
| **RAG / Vector DB** | In-memory list + cosine similarity | Stores embeddings of verified queries |
| **Verification Layer** | Google Sheets (`utils/gspread_client.py`) | Manual review and approval pipeline |
| **Database** | PostgreSQL + Psycopg2 | Persistent storage and secure query execution |

---

## ⚙️ Setup & Installation

### 1️⃣ Prerequisites

You will need:
- A **Google Gemini API Key**
- A **Google Sheets Service Account JSON key**
- A running **PostgreSQL** instance

---

### 2️⃣ Python Environment

Create a virtual environment and install dependencies:

```bash
pip install -r requirements.txt
