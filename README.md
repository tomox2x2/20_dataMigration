# Oracle → PostgreSQL 移行 PoC（性能改善検証）

## ■ 概要
Oracle Database から PostgreSQL への移行および、既存SQLのパフォーマンス改善を目的としたPoC（概念実証）です。  
会計系データ（仕訳・勘定科目）を対象に、スキーマ変換・データ移行・SQLチューニングを実施しました。

---

## ■ 背景
- Oracle ライセンスコスト削減（OSS化）
- クラウド移行（AWS RDS想定）
- PostgreSQL におけるパフォーマンスチューニング技術の習得

---

## ■ 成果（ハイライト）

- 最大 **70%の性能改善** を達成
- 約 **100万件のデータ移行** を実施
- クエリ改善：**7本**

| クエリ | Before | After | 改善率 |
|--------|--------|--------|--------|
| 集約クエリ | 0.225秒 | 0.069秒 | 70% |
| JOINクエリ | 0.082秒 | 0.068秒 | 17% |
| サブクエリ | 0.674秒 | 0.556秒 | 17% |

---

## ■ 技術スタック

- DB：Oracle / PostgreSQL
- 環境：Docker / AWS RDS（想定）
- ツール：AWS Schema Conversion Tool（SCT）、Ora2Pg
- 言語：SQL / Python

---

## ■ システム構成

### As-Is（移行前）
- Oracle XE（Docker）
- ローカル環境

### To-Be（移行後）
- PostgreSQL（RDS想定 or Docker）
- AWS（VPC / Security Group）

※ 構成図は docs 配下または下記 Notion を参照

---

## ■ 移行方式

- スキーマ：AWS Schema Conversion Tool（SCT）でDDL生成
- データ　：Ora2Pg により COPY 文を生成し移行

※ スキーマ変換とデータ移行を分離することで、変換精度と移行効率を両立

---

## ■ パフォーマンス改善（抜粋）

### ケース①：集約クエリの高速化

**課題**
- Bitmap Heap Scan によるI/Oコスト増大

**対応**
- カバリングインデックス作成（INCLUDE句）
- Index Only Scan化
- DATE_TRUNC による型維持

```sql
CREATE INDEX idx_jd_cover_1
ON act1.t_journal_detail (account_id, journal_id)
INCLUDE (debit_amount, credit_amount);
```
---

## ■ 結果

0.225秒 → 0.069秒（70%改善）

---

## ■ ケース②：JOIN前のデータ削減

### ■ 課題
JOIN前のデータ量が多く非効率

### ■ 対応
- 高選択度条件（JOURNAL_ID）を先に適用
- インデックス利用効率を向上

### ■ 結果
0.082秒 → 0.068秒（17%改善）

---

## ■ ケース③：スカラサブクエリの最適化

### ■ 課題
行単位でサブクエリが実行される（N回実行）

### ■ 対応
- インデックス追加
- 並列実行設定（max_parallel_workers_per_gather）

### ■ 結果
0.674秒 → 0.556秒（17%改善）

### ■ 改善余地
JOIN + GROUP BY による一括集計で更なる高速化が可能

---

## ■ 重要な知見

- PostgreSQLはヒント句が存在しないため、インデックス設計とSQL構造が重要
- Index Only ScanはVisibility Mapの状態に依存
- VACUUM / ANALYZE により有効化される
- 統計情報により実行計画が大きく変化する
- JOIN順はコストベース最適化により決定される

---

## ■ ディレクトリ構成
.
├── oracle/        # Oracle DDL・データ生成スクリプト
├── postgres/      # PostgreSQL DDL・COPY文
├── sql/           # 実行SQL
├── explain/       # 実行計画（Before / After）
├── docs/          # 詳細資料
└── docker/        # 環境構築（任意）


---

## ■ 再現手順（簡易）

1. Oracle環境をDockerで起動  
2. Pythonスクリプトでデータ生成  
3. Ora2PgでCOPY文生成  
4. PostgreSQLにデータロード  
5. SQL実行・性能比較  

---

## ■ トラブルシュート

### ■ COPY時の `\N` エラー
- 原因：スキーマ指定不足  
- 対応：テーブル名にスキーマを明示  

### ■ RDS接続エラー
- 原因：Security Group設定  
- 対応：ポート開放  

### ■ タイムアウト
- 原因：VPC / ネットワーク設定  
- 対応：ネットワーク設定見直し  

---

## ■ 今後の課題

- パーティショニング導入  
- マテリアライズドビュー活用  
- 照会用データの事前集計  
- JOINベースへのクエリ書き換えによる最適化  

---

## ■ 詳細ドキュメント（Notion）

より詳細な検証内容・構成図はこちら  
https://lying-floor-e0b.notion.site/Oracle-PostgreSQL-PoC-22a8fd51d71d80e89186ee67e1d2a02b