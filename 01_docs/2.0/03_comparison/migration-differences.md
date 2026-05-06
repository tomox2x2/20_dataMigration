# Oracle → PostgreSQL 移植時の差異

## 概要

本PoCで確認した、OracleとPostgreSQLの実装差異をまとめる。

---

## SQL関数

| Oracle | PostgreSQL | 備考 |
|---------|------------|------|
| ADD_MONTHS | + INTERVAL | 月加算 |
| SYSDATE | CLOCK_TIMESTAMP | 現在日時 / PoCでは逐次時刻を取得したかったため、CLOCK_TIMESTAMPを使用 |
| TO_CHAR | TO_CHAR | ほぼ同等 |

---

## PL/SQL

| Oracle | PostgreSQL |
|---------|------------|
| DBMS_OUTPUT.PUT_LINE | RAISE NOTICE |
| DBMS_METADATA.GET_DDL | pg_indexes の indexdef を利用 |
| EXECUTE IMMEDIATE | EXECUTE |
| DBMS_STATS.GATHER_TABLE_STATS | ANALYZE                            |
| FOR LOOP | FOR LOOP |

---

## データ型

| Oracle | PostgreSQL |
|---------|------------|
| VARCHAR2 | VARCHAR |
| NUMBER | NUMERIC / INTEGER |
| DATE | TIMESTAMP |

---

## メタデータ

| Oracle | PostgreSQL |
|---------|------------|
| USER_TABLES | pg_tables |
| USER_INDEXES | pg_indexes |

---

## 実装上の変更点

- DBMS_OUTPUT を RAISE NOTICE に変更
- DBMS_STATS を ANALYZE に変更
- DBMS_METADATA は PostgreSQL 用に再実装
- Oracle 独自構文を PostgreSQL 構文へ置換

---

## 所感

移植の大部分は構文変換で対応できたが、
Oracle固有パッケージ(DBMS_*)については代替方法の検討が必要であった。
