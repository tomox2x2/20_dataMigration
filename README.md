# Oracle → PostgreSQL Migration PoC

Oracle Database を PostgreSQL へ移行することを想定し、
スキーマ・SQL・ストアドプロシージャの移植、および性能比較・実行計画比較を実施した
Proof of Concept（PoC）です。

会計システムを想定したデータモデルを利用し、
Oracle と PostgreSQL の実装差異や性能特性について検証を行いました。

---

## Repository Map

初めて読む方はこちらをご覧ください。

1.README.md

2.PoC 概要

 (Ver.1.0)

  - 01_docs/1.0/architecture.md
  - 01_docs/1.0/migration.md
  - 01_docs/1.0/performance.md

 (Ver.2.0)

  - 01_docs/2.0/overview.md

3.Oracle→PostgreSQL差異

 (Ver.1.0)
  - 01_docs/1.0/performance.md(☆)

 (Ver.2.0)
  - 01_docs/2.0/03_comprison/summary.md

4.SQL性能比較

 (Ver.1.0)
  - 01_docs/1.0/performance.md(☆)

 (Ver.2.0)
  - 01_docs/2.0/03_comprison/sql-performance.md

5.実行計画比較

 (Ver.1.0)
  - 01_docs/1.0/performance.md(☆)

 (Ver.2.0)
  - 01_docs/2.0/03_comprison/execution-plan.md

---

## Executive Summary

本PoCでは、Oracle DatabaseからPostgreSQLへの移行を想定し、

・スキーマ移植

・PL/SQL移植

・SQL性能比較

・実行計画比較

・AWS RDS検証

までを一貫して実施しました。
その結果、

・OracleとPostgreSQLでは実行計画の選択が異なること
・SQLだけではなくデータ設計が性能へ大きく影響すること
・事前集約テーブルが照会性能改善に非常に有効であること

などを確認しました。

---

## Highlights

- Oracle→PostgreSQL移行PoCをGitHub公開
- 約100万件データによる性能比較
- SQL18種類・Procedure5本比較
- Oracle/PostgreSQL実行計画比較
- 最大98%高速化を確認
- AWS RDS上でも動作検証

---

## PoC概要

本リポジトリでは、Oracle → PostgreSQL 移行を段階的に検証しています。

| Version | 目的 | 主な検証内容 |
|----------|-----|---------------|
| **Ver.1.0**  | 移行手順、Oracle vs PostgreSQL間のSQLクエリ関連差異確認  | Oracle → PostgreSQL スキーマ移植、データ移行、AWS RDS構築、SQLチューニング |
| **Ver.2.0** | プロシージャ移行、Ver.1.0 大量データ取得の改善  | PL/SQL → PL/pgSQL移植、SQL・Procedure性能比較、実行計画比較、事前集約テーブルの性能検証 |

---

## Ver.2.0 の主な追加内容

Ver.1.0 の内容に加え、以下の検証を追加しました。

- PL/SQL → PL/pgSQL の移植
- ストアドプロシージャ性能比較
- SQL性能比較
- Oracle / PostgreSQL 実行計画比較
- Oracle固有機能の移植方法整理
- 事前集約テーブルによる性能改善効果の検証

---

## 背景

本PoCは以下を目的として実施しました。

- Oracle Database から PostgreSQL への移行検証
- OSSデータベースへの移行技術習得
- PostgreSQL の性能特性理解
- Oracle と PostgreSQL の実装差異の理解
- クラウド環境（AWS RDS）への適用性確認

---

## 実施内容

### Oracle → PostgreSQL 移植

- DDL移植（テーブル・インデックス・ストアドプロシージャ）
- DML移植
- データ移行

---

### 性能比較

以下について比較・評価を実施しました。

- Oracle vs PostgreSQL
- SQL性能比較
- Procedure性能比較
- 実行計画比較
- 事前集約による効果（結合クエリと集約済みデータの比較）

---

### 検証環境

|項目|内容|
|---|---|
|Host OS|Windows 11|
|Linux|WSL2 (AlmaLinux 9.7)|
|Container|Docker|
|Oracle|Oracle Database 21c XE|
|PostgreSQL|PostgreSQL 16|

※ Ver.1.0では PostgreSQL を AWS RDS 上でも構築し、接続および動作検証を実施しました。

---

## 主な成果

### Oracle → PostgreSQL 移植

- ✅ 全テーブル移植
- ✅ 全ストアドプロシージャ移植
- ✅ SQL移植
- ✅ Oracleとの処理結果一致

---

### SQL性能比較

18種類のSQLについて比較を実施しました。

#### 比較内容

- Oracle vs PostgreSQL
- 結合クエリ
- 集約済みデータ

#### 結果

- PostgreSQLは大量データ検索で高い性能を確認
- Oracleは一部集約処理で優位な結果を確認
- ワークロード特性によって性能傾向が変化することを確認

---

### Procedure性能比較

5本のProcedureについて比較しました。

- proc_set_inquirydata : 改善率   4.5 ( 12s / 263s)
- proc_set_journal     : 改善率   3.4 (  9s / 261s)
- proc_set_settl_m     : 改善率 400   (  4s / 1s)
- proc_set_settl_y     : 改善率 100   (  0s / 0s)

※：改善率 = PostgreSQL 実行平均時間 ÷  Oracle 実行平均時間
   子プロシージャの実行時間を含む

Procedureごとに異なる性能傾向が見られ、
実行計画の違いが性能へ大きく影響することを確認しました。

---

#### 実行計画比較

Oracle

- INDEX RANGE SCAN
- TABLE ACCESS BY INDEX ROWID
- HASH JOIN

PostgreSQL

- Bitmap Index Scan
- Bitmap Heap Scan
- Hash Join
- Incremental Sort
- Memoize

Oracle と PostgreSQL では、
同一SQLであっても異なる実行計画が選択されることを確認しました。

---

#### 事前集約テーブルの検証

照会用に月別・年度別精算表を事前作成し、
結合クエリとの性能比較を実施しました。

結果

- SQL実行時間を最大約98%削減
- JOIN回数削減による実行計画の単純化
- 集約系照会で大きな効果を確認

---

## 技術スタック

### Database

- Oracle Database 21c XE
- PostgreSQL 16

### Language

- SQL
- PL/SQL
- PL/pgSQL

### Infrastructure

- Windows 11
- WSL2
- Docker
- AWS RDS（Ver.1.0）

### Tools

- Docker Compose
- Git
- GitHub
- DBeaver
- pgAdmin
- EXPLAIN / ANALYZE

---

## ディレクトリ構成

```text
.
├── 01_docs
│   ├── 1.0
│   └── 2.0
│       ├── 01_Oracle
│       ├── 02_PostgreSQL
│       └── 03_Comparison
├── oracle
│   ├── ddl
│   ├── data
│   └── procedure
│
├── postgresql
│   ├── ddl
│   ├── data
│   └── procedure
│
├── sql
│
│
└── docker
```

---

## ドキュメント

### Ver.1.0

- アーキテクチャ構成
- データベース移行手順
- パフォーマンスチューニング
- トラブルシューティング

### Ver.2.0

#### Oracle

- 処理概要
- テーブル設計
- Procedure詳細
- Procedureフロー
- 実行例

#### PostgreSQL

- 処理概要
- テーブル設計
- Procedure詳細
- Procedureフロー
- 実行例
- プロシージャ移植差異

#### 比較資料

- PoCまとめ
- Oracle → PostgreSQL 移植差異
- SQL性能比較
- 実行計画比較

---

## 主な知見

本PoCを通して以下の知見を得ることができました。

- Oracle と PostgreSQL では実行計画の選択方針が異なる
- PostgreSQLでは統計情報やインデックス設計が性能へ大きく影響する
- Oracle固有パッケージ（DBMS_*）は代替実装が必要
- 事前集約テーブルは照会性能改善に非常に有効
- SQLだけではなく、データ設計も性能へ大きく影響する

---

## 今後の課題

- PostgreSQL / プロシージャ内クエリの実行計画チューニング
- インデックス設計の最適化
- 大規模データでの性能評価
- AWS RDS環境での追加検証
- PostgreSQL固有機能を利用した更なる性能改善

---

## ライセンス

本リポジトリは学習および技術検証を目的として作成しています。
