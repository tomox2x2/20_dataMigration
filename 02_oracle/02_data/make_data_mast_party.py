import oracledb
from faker import Faker
from config import DB_CONFIG

fake = Faker()

conn = oracledb.connect(**DB_CONFIG)

cursor = conn.cursor()

# company
cursor.execute("delete from m_party")

rows = []

# 100件作成
for i in range(1, 101):
    rows.append((
        i,
        f"P{i:04}",
        fake.company()
    ))

cursor.executemany("""
    INSERT INTO m_party (party_id, party_code, party_name)
    VALUES (:1, :2, :3)
""", rows)

conn.commit()
cursor.close()
conn.close()