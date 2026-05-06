import oracledb
import random
from datetime import datetime, timedelta
from config import DB_CONFIG

# ===== 設定 =====
HEADER_COUNT = 100_000
DETAIL_PER_HEADER = 10
BATCH_SIZE = 10000

# ACCOUNT_IDS = list(range(1, 41))  # accountは40件想定
ACCOUNT_IDS = None  # 後でDBから取得

# ===== 接続 =====
conn = oracledb.connect(**DB_CONFIG)
cursor = conn.cursor()

# 高速化
cursor.fast_executemany = True

# ===== 日付生成 =====
def random_date():
    start = datetime(2026, 1, 1)
    end = datetime(2026, 12, 31)
    delta = end - start
    return start + timedelta(days=random.randint(0, delta.days))

# # ===== 勘定科目の取得 =====
# def get_account_ids():
#     cursor.execute("SELECT account_id FROM m_account")
#     rows = cursor.fetchall()
#     return [r[0] for r in rows]

# ===== ヘッダ生成 =====
def generate_headers():
    print("Clear journal_header...")
    cursor.execute("delete from t_journal_header")
    conn.commit()
    
    print("Generating journal_header...")

    for batch_start in range(0, HEADER_COUNT, BATCH_SIZE):
        rows = []

        for i in range(batch_start, batch_start + BATCH_SIZE):
            journal_id = i + 1
            rows.append((
                journal_id,
                random.randint(1, 10),   # company_id
                random.randint(1, 100),  # party_id
                random_date(),
                f"仕訳{journal_id}"
            ))

        cursor.executemany("""
            INSERT INTO t_journal_header
            (journal_id, company_id, party_id, journal_date, description)
            VALUES (:1, :2, :3, :4, :5)
        """, rows)

        conn.commit()
        print(f"Header batch {batch_start} done")

# # ===== 明細生成 =====
# def generate_details():
#     print("Clear journal_detail...")
#     cursor.execute("delete from t_journal_detail")
#     conn.commit()

#     print("Generating t_journal_detail...")

#     detail_id = 1

#     for batch_start in range(0, HEADER_COUNT, BATCH_SIZE):
#         rows = []

#         for j in range(batch_start, batch_start + BATCH_SIZE):
#             journal_id = j + 1

#             total = random.randint(1000, 100000)

#             # 借方
#             rows.append((
#                 detail_id,
#                 journal_id,
#                 1,
#                 random.choice(ACCOUNT_IDS),
#                 total,
#                 None
#             ))
#             detail_id += 1

#             # 貸方
#             rows.append((
#                 detail_id,
#                 journal_id,
#                 2,
#                 random.choice(ACCOUNT_IDS),
#                 None,
#                 total
#             ))
#             detail_id += 1

#             # 追加明細（任意）
#             for line in range(3, DETAIL_PER_HEADER + 1):
#                 amount = random.randint(100, 10000)

#                 if line % 2 == 0:
#                     debit = amount
#                     credit = None
#                 else:
#                     debit = None
#                     credit = amount

#                 rows.append((
#                     detail_id,
#                     journal_id,
#                     line,
#                     random.choice(ACCOUNT_IDS),
#                     debit,
#                     credit
#                 ))
#                 detail_id += 1

#         cursor.executemany("""
#             INSERT INTO t_journal_detail
#             (detail_id, journal_id, line_no, account_id, debit_amount, credit_amount)
#             VALUES (:1, :2, :3, :4, :5, :6)
#         """, rows)

#         conn.commit()
#         print(f"Detail batch {batch_start} done")

# ===== 実行 =====
if __name__ == "__main__":

    generate_headers()
    cursor.close()
    conn.close()

    print("Done!")
