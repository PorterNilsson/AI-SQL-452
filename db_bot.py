"""Batch natural-language-to-SQL experiment for the blood-bank database."""

import json
import os
import re
import sqlite3
from datetime import datetime
from pathlib import Path

PROJECT_DIR = Path(__file__).resolve().parent
DATABASE_PATH = PROJECT_DIR / "aidb.sqlite"
SCHEMA_PATH = PROJECT_DIR / "setup.sql"
DATA_PATH = PROJECT_DIR / "setupData.sql"
MODEL = os.environ.get("OPENAI_MODEL", "gpt-4o")


def read_prompt_context() -> str:
    return SCHEMA_PATH.read_text(encoding="utf-8")


def create_database() -> sqlite3.Connection:
    """Rebuild the local database from the checked-in schema and seed data."""
    if DATABASE_PATH.exists():
        DATABASE_PATH.unlink()

    connection = sqlite3.connect(DATABASE_PATH)
    connection.row_factory = sqlite3.Row
    connection.execute("PRAGMA foreign_keys = ON")
    connection.executescript(SCHEMA_PATH.read_text(encoding="utf-8"))
    connection.executescript(DATA_PATH.read_text(encoding="utf-8"))
    # The generated SQL is for answering questions only; prevent data changes.
    connection.execute("PRAGMA query_only = ON")
    return connection


def run_sql(connection: sqlite3.Connection, query: str) -> list[dict]:
    """Execute one read-only SELECT and return rows with their column names."""
    sql = query.strip()
    if sql.endswith(";"):
        sql = sql[:-1].rstrip()
    if not re.match(r"^(SELECT|WITH)\b", sql, re.IGNORECASE):
        raise ValueError("Only read-only SELECT queries are allowed.")
    if ";" in sql:
        raise ValueError("Only one SQL statement is allowed per question.")
    cursor = connection.execute(sql)
    return [dict(row) for row in cursor.fetchall()]


def get_chat_response(client, prompt: str) -> str:
    response = client.chat.completions.create(
        model=MODEL,
        messages=[{"role": "user", "content": prompt}],
    )
    return (response.choices[0].message.content or "").strip()


def sanitize_sql(response: str) -> str:
    """Remove an optional Markdown SQL fence from a generated query."""
    match = re.search(r"```(?:sql|sqlite)?\s*(.*?)```", response, re.IGNORECASE | re.DOTALL)
    return (match.group(1) if match else response).strip()


def make_strategies(schema: str) -> dict[str, str]:
    instructions = (
        "Generate one SQLite SELECT statement that answers the question. "
        "Use only tables and columns in the schema. Return SQL only, without "
        "Markdown fences or explanation. Do not modify data.\n\n"
    )
    zero_shot = "Database schema:\n" + schema + "\n\n" + instructions
    single_domain_example = (
        "Example question: Which donors have given more than one donation?\n"
        "Example SQL:\n"
        "SELECT p.first_name, p.last_name, COUNT(d.id) AS donation_count\n"
        "FROM donor AS dr\n"
        "JOIN person AS p ON p.id = dr.person_id\n"
        "JOIN donations AS d ON d.donor_id = dr.id\n"
        "GROUP BY dr.id, p.first_name, p.last_name\n"
        "HAVING COUNT(d.id) > 1;\n\n"
    )
    single_domain = (
        "Database schema:\n" + schema + "\n\n" + single_domain_example + instructions
    )
    return {"zero_shot": zero_shot, "single_domain": single_domain}


def main() -> None:
    api_key = os.environ.get("OPENAPI_KEY")
    if not api_key:
        raise SystemExit(
            "OPENAPI_KEY is not set. Add your key to the ignored .env file, then run `make run`."
        )

    from openai import OpenAI

    client = OpenAI(api_key=api_key)
    schema = read_prompt_context()
    strategies = make_strategies(schema)
    questions = [
        "How many donors are registered for each blood type?",
        "Which donors have given more than one donation?",
        "How many donations were made at each location?",
        "Which donors have a medical condition recorded?",
        "Which staff members work at the Provo location?",
        "What is the total amount donated by each donor?",
        "Which donors have not made a donation?",
        "What was the most recent donation date?",
    ]

    connection = create_database()
    try:
        for strategy_name, prompt_prefix in strategies.items():
            results = {"strategy": strategy_name, "questionResults": []}
            print("#" * 72)
            print(f"Prompting strategy: {strategy_name}")

            for question in questions:
                print("\n" + "~" * 72)
                print(f"Question: {question}")
                result = {
                    "question": question,
                    "sql": "",
                    "queryRawResponse": "",
                    "friendlyResponse": "",
                    "error": None,
                }
                try:
                    result["sql"] = sanitize_sql(
                        get_chat_response(client, prompt_prefix + "Question: " + question)
                    )
                    print(f"Generated SQL:\n{result['sql']}")
                    rows = run_sql(connection, result["sql"])
                    result["queryRawResponse"] = rows
                    print(f"Rows: {json.dumps(rows, ensure_ascii=False)}")

                    answer_prompt = (
                        "Answer the user's question using only the database result below. "
                        "Give a concise, friendly answer. If the result is empty, say that "
                        "no matching records were found. Do not invent facts.\n\n"
                        f"Question: {question}\n"
                        f"Result columns and rows: {json.dumps(rows, ensure_ascii=False)}"
                    )
                    result["friendlyResponse"] = get_chat_response(client, answer_prompt)
                    print(f"Friendly answer: {result['friendlyResponse']}")
                except Exception as error:  # Keep a failed experiment in the report.
                    result["error"] = str(error)
                    print(f"Error: {error}")
                results["questionResults"].append(result)

            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_path = PROJECT_DIR / f"response_{strategy_name}_{timestamp}.json"
            output_path.write_text(json.dumps(results, indent=2), encoding="utf-8")
            print(f"Saved results to {output_path.name}")
    finally:
        connection.close()


if __name__ == "__main__":
    main()
