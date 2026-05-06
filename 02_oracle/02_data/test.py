import oracledb
from config import DB_CONFIG

conn = oracledb.connect(**DB_CONFIG)
print("Connected OK")
conn.close()
