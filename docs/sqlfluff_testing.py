from sqlfluff.core import Linter

def check_sql_syntax(sql: str, dialect: str = "ansi"):
    """
    Validate SQL syntax using sqlfluff.
    Returns True if syntax is correct, otherwise False.
    """
    linter = Linter(dialect=dialect)
    parsed = linter.parse_string(sql)
    
    if parsed.violations:
        return False
    return True

queries = [
    "SELECT * FROM foo;",     # correct
    "SELECT + FROM bar;",   # incorrect
]

for q in queries:
    if check_sql_syntax(q, "mysql"):
        print(f"✅ Syntax OK: {q}")
    else:
        print(f"❌ Syntax Error: {q}")
