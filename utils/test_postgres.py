import psycopg2

def test_postgres():
    try:
        # Update with your credentials
        conn = psycopg2.connect(
            host="localhost",
            port="5432",
            database="postgres",   # change if you have a different DB
            user="postgres",       # your username
            password="lucky535"  # your password
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        db_version = cur.fetchone()
        print("✅ Connected to PostgreSQL:", db_version)

        # Test a sample query on your schema
        cur.execute("SELECT * FROM users;")
        rows = cur.fetchall()
        print("Sample rows :")
        for row in rows:
            print(row)

        cur.close()
        conn.close()
    except Exception as e:
        print("❌ Error:", e)

if __name__ == "__main__":
    test_postgres()


