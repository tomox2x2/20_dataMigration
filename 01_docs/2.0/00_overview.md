# Oracle → PostgreSQL PoC v2.0

## 目的

Oracleで動作している会計システムを
PostgreSQLへ移行した場合の

・機能互換性
・性能
・実装差異

を検証する。

---

## 検証内容

- テーブル移植
- Index移植
- Procedure移植
- SQL移植
- EXPLAIN比較
- 実行時間比較

---

## 成果

✔ 全Procedure移植完了

✔ Oracleとの処理結果一致

✔ SQL性能比較完了

✔ 実行計画比較完了

✔ PostgreSQL特有のチューニングポイント整理
