import oracledb
import random
from config import DB_CONFIG

TARGET_DETAIL_COUNT = 1_000_000
BATCH_SIZE = 10000

conn = oracledb.connect(**DB_CONFIG)
cursor = conn.cursor()
cursor.fast_executemany = True

# ===== account取得 =====
def get_account_ids(cursor):
    cursor.execute("SELECT account_id FROM m_account")
    return [r[0] for r in cursor.fetchall()]

ACCOUNT_IDS = get_account_ids(cursor)

print("Clear journal_detail...")
cursor.execute("delete from t_journal_detail")
conn.commit()

# ===== header数取得 =====
cursor.execute("SELECT COUNT(*) FROM t_journal_header")
HEADER_COUNT = cursor.fetchone()[0]

print(f"Header count: {HEADER_COUNT}")

detail_id = 1
total_inserted = 0

print("Generating journal_detail...")

rows = []

for journal_id in range(1, HEADER_COUNT + 1):

    # 残件数から安全に生成数を決める
    remaining = TARGET_DETAIL_COUNT - total_inserted
    if remaining <= 0:
        break

    max_lines = min(15, remaining)
    min_lines = min(2, remaining)

    line_count = random.randint(min_lines, max_lines)

    debit_total = 0
    credit_total = 0

    for line_no in range(1, line_count + 1):

        # 最終行で調整
        if line_no == line_count:
            if debit_total > credit_total:
                debit = None
                credit = debit_total - credit_total
            else:
                debit = credit_total - debit_total
                credit = None
        else:
            amount = random.randint(100, 10000)

            if random.choice([True, False]):
                debit = amount
                credit = None
                debit_total += amount
            else:
                debit = None
                credit = amount
                credit_total += amount

        rows.append((
            detail_id,
            journal_id,
            line_no,
            random.choice(ACCOUNT_IDS),
            debit,
            credit
        ))

        detail_id += 1
        total_inserted += 1

        # バッチ投入
        if len(rows) >= BATCH_SIZE:
            cursor.executemany("""
                INSERT INTO t_journal_detail
                (detail_id, journal_id, line_no, account_id, debit_amount, credit_amount)
                VALUES (:1, :2, :3, :4, :5, :6)
            """, rows)

            conn.commit()
            print(f"Inserted: {total_inserted}")

            rows = []

        if total_inserted >= TARGET_DETAIL_COUNT:
            break

# 残り投入
if rows:
    cursor.executemany("""
        INSERT INTO t_journal_detail
        (detail_id, journal_id, line_no, account_id, debit_amount, credit_amount)
        VALUES (:1, :2, :3, :4, :5, :6)
    """, rows)
    conn.commit()

print(f"Done! Total inserted: {total_inserted}")

cursor.close()
conn.close()
