import oracledb
from faker import Faker
from config import DB_CONFIG

fake = Faker()

conn = oracledb.connect(**DB_CONFIG)

cursor = conn.cursor()

# company
cursor.execute("delete from m_company")

for i in range(1, 11):
    cursor.execute("""
        INSERT INTO m_company (company_id, company_code, company_name, created_at)
        VALUES (:1, :2, :3, sysdate)
    """, [i, f"C{i:03}", fake.company()])

conn.commit()
cursor.close()
conn.close()