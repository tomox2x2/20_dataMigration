
| Oracle            | PostgreSQL       |
| ----------------- | ---------------- |
| DBMS_METADATA     | pg_indexes       |
| DBMS_STATS        | ANALYZE          |
| DBMS_OUTPUT       | RAISE NOTICE     |
| EXECUTE IMMEDIATE | EXECUTE          |
| ADD_MONTHS        | interval         |
| USER_TABLES       | pg_tables        |
| USER_INDEXES      | pg_indexes       |


| Oracle特有機能                    | PostgreSQLでの代替方法                   |
| ----------------------------- | ---------------------------------- |
| DBMS_METADATA.GET_DDL         | pg_indexes の indexdef を利用してDDLを再生成 |
| DBMS_STATS.GATHER_TABLE_STATS | ANALYZE                            |
| EXECUTE IMMEDIATE             | EXECUTE                            |
| DBMS_OUTPUT.PUT_LINE          | RAISE NOTICE                       |
