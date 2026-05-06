# パフォーマンステスト実施条件

ハードウェア性能差異による影響を排除するため、  
Oracle XE および PostgreSQL の両環境は、同一の WSL2 + Docker ホスト上に構築し、測定を実施した。

---

## 実行環境

| 項目 | 内容 |
|---|---|
| ホストOS | Windows 11 |
| WSL | WSL2 |
| Linuxディストリビューション | AlmaLinuxOS 9.7 |
| Docker Engine | 29.4.0 |
| Docker Compose | v5.1.1 | 

---

## ハードウェア構成

| 項目 | 内容 |
|---|---|
| CPU | AMD Ryzen 7 Extreme Edition |
| 論理CPU数 | 16 |
| コアあたりスレッド数 | 2 |
| コア数 | 8 |
| メモリ | 7.5GB |
| ストレージ | SSD |

---

## データベース構成

| 項目 | 内容 |
|---|---|
| Oracle | Oracle Database 21c Express Edition Release 21.0.0.0.0 |
| PostgreSQL | PostgreSQL 16.13 |

---

## Docker リソース設定

| 項目 | 内容 |
|---|---|
| CPU制限 | 制限なし |
| メモリ制限 | 制限なし |

---

## 測定ルール

- 各クエリおよびプロシージャは 5 回実行
- 最大値および最小値を除外
- 残り 3 回の平均値を評価値として採用
- キャッシュウォーム状態で測定を実施
- Oracle は `EXPLAIN PLAN`、PostgreSQL は `EXPLAIN ANALYZE` を取得
- 測定前に統計情報を更新
- Oracle / PostgreSQL は同一ホスト上で実施
- 測定中は他の高負荷処理を停止

---

## テストデータ件数

| テーブル名 | レコード件数 |
|---|---|
| m_account | 100,000 |
| m_company | 100,000 |
| m_party | 100,000 |
| journal_header | 100,000 |
| journal_detail | 850,836 |
