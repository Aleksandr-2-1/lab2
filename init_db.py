from pathlib import Path
import sqlite3

project_dir = Path(__file__).resolve().parent
db_path = project_dir / "equipment.db"
schema_path = project_dir / "schema.sql"

if db_path.exists():
    db_path.unlink()

with sqlite3.connect(db_path) as connection:
    connection.execute("PRAGMA foreign_keys = ON")
    connection.executescript(schema_path.read_text(encoding="utf-8"))
    tables = ["departments", "employees", "equipment", "movements", "repairs"]
    print(f"База данных создана: {db_path.name}")
    for table in tables:
        count = connection.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        print(f"{table}: {count} записей")
    errors = connection.execute("PRAGMA foreign_key_check").fetchall()
    print("Проверка внешних ключей:", "ошибок нет" if not errors else errors)
