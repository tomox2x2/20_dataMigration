import oracledb
from faker import Faker
from config import DB_CONFIG

fake = Faker()

accounts = [
    # ===== 資産（ASSET）=====
    ("1000", "現金", "ASSET"),
    ("1010", "普通預金", "ASSET"),
    ("1020", "当座預金", "ASSET"),
    ("1100", "売掛金", "ASSET"),
    ("1110", "受取手形", "ASSET"),
    ("1200", "棚卸資産", "ASSET"),
    ("1300", "前払費用", "ASSET"),
    ("1400", "貸付金", "ASSET"),
    ("1500", "建物", "ASSET"),
    ("1510", "備品", "ASSET"),
    ("1520", "車両運搬具", "ASSET"),
    ("1600", "減価償却累計額", "ASSET"),  # マイナス資産的扱い

    # ===== 負債（LIABILITY）=====
    ("2000", "買掛金", "LIABILITY"),
    ("2010", "支払手形", "LIABILITY"),
    ("2100", "未払金", "LIABILITY"),
    ("2110", "未払費用", "LIABILITY"),
    ("2200", "前受収益", "LIABILITY"),
    ("2300", "借入金", "LIABILITY"),
    ("2400", "預り金", "LIABILITY"),

    # ===== 純資産（EQUITY）=====
    ("3000", "資本金", "EQUITY"),
    ("3100", "資本剰余金", "EQUITY"),
    ("3200", "利益剰余金", "EQUITY"),

    # ===== 収益（REVENUE）=====
    ("4000", "売上高", "REVENUE"),
    ("4010", "受取利息", "REVENUE"),
    ("4020", "受取配当金", "REVENUE"),
    ("4100", "雑収入", "REVENUE"),

    # ===== 費用（EXPENSE）=====
    ("5000", "売上原価", "EXPENSE"),
    ("5100", "給与", "EXPENSE"),
    ("5110", "賞与", "EXPENSE"),
    ("5200", "旅費交通費", "EXPENSE"),
    ("5300", "通信費", "EXPENSE"),
    ("5400", "消耗品費", "EXPENSE"),
    ("5500", "地代家賃", "EXPENSE"),
    ("5600", "水道光熱費", "EXPENSE"),
    ("5700", "減価償却費", "EXPENSE"),
    ("5800", "支払利息", "EXPENSE"),
    ("5900", "雑費", "EXPENSE"),
]

conn = oracledb.connect(**DB_CONFIG)

cursor = conn.cursor()

# account
cursor.execute("delete from m_account")

rows = []

for i, (code, name, acc_type) in enumerate(accounts, start=1):
    rows.append((
        i,
        code,
        name,
        acc_type
    ))

cursor.executemany("""
    INSERT INTO m_account (account_id, account_code, account_name, account_type)
    VALUES (:1, :2, :3, :4)
""", rows)

conn.commit()
cursor.close()
conn.close()
