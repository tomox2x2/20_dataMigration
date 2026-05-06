# 実行計画比較

## 1. Oracle vs PostgreSQL

### 概要

OracleとPostgreSQLで同一SQLを実行し、実行計画を比較した。

---

### 比較対象

- 結合クエリ(JOIN / GROUP BY / ORDER BY)
- 集約済みデータ取得クエリ(ORDER BY)

---

### Oracle

#### 特徴

- INDEX RANGE SCAN
- TABLE ACCESS BY INDEX ROWID
- HASH JOIN
- SORT GROUP BY

---

### PostgreSQL

#### 特徴

- Bitmap Index Scan
- Bitmap Heap Scan
- Hash Join
- Aggregate

---

### 相違点

| Oracle | PostgreSQL |
|---------|------------|
| TABLE ACCESS BY ROWID | Bitmap Heap Scan |
| SORT GROUP BY | HashAggregate |
| INDEX RANGE SCAN | Bitmap Index Scan |

---

### 考察

#### 結合クエリ
- OracleとPostgreSQLの性能差は、主としてオプティマイザによる実行計画選択方針の違いに起因する。
- Oracleは条件絞り込み時に OracleはNested LoopやHash Joinを状況に応じて使い分け、
  Index Range Scanを積極的に利用した。
- PostgreSQLは Hash Join と Bitmap Scan を積極的に利用する傾向があった。
  また、必要に応じて Parallel Seq Scan が選択された。
  (取得件数が数万件規模まで減少するケースでは Oracle より不利となる傾向が確認された)
- 両DBの優劣というよりも、ワークロード特性に応じて有利な実行計画が異なることが確認できた。

#### 集約済みデータ取得
- OracleとPostgreSQLのオプティマイザが選択したアクセス方式に違いが見られた。
- 特に大規模テーブルでは、Oracleがフルスキャン＋ソートを選択するケースが多かったのに対し、
  PostgreSQLはインデックス走査やBitmap Scanを利用して対象データを効率的に取得していた。
- 一方で、データ量が小さい集約テーブルでは両DBとも全件読込を選択しており、性能差はほとんど発生しなかった。

---

## 2. Oracle 結合 vs 集約済みデータ

### 概要

Oracle側で、ヘッダ+明細データを結合したクエリと
集約済みのデータを取得した場合の比較を行った

---

### 比較対象

- 仕訳明細データ
- 月別精算表データ
- 年度別精算表データ

---

### 結合クエリ

#### 特徴

- SORT GROUP BY
- HASH JOIN
- TABLE ACCESS FULL
- INDEX RANGE SCAN
- NESTED LOOP / INDEX UNIQUE SCAN (少数データを格納するマスタ読み込み時に使用)
- BITMAP CONVERSION FROM ROWIDS

---

### 集約済みデータ

#### 特徴

- SORT GROUP BY
- TABLE ACCESS FULL
- INDEX RANGE SCAN
- FILTER(少数データを絞り込む際に使用)

---

### 相違点

結合クエリ側で HASH JOIN していた分だけ、
集約済みデータ取得時は実行計画の内容は大幅にシンプルになっていた。

---

### 考察

- クエリ実行自体の処理速度は 30~98 % 程度削減。
- 仕訳明細データではソート処理に同様のコストが発生していた。
- 予め集約している精算表データでは圧倒的にコストが削減された。

---

## 3. PostgreSQL 結合 vs 集約済みデータ

### 概要

PostgreSQL側で、ヘッダ+明細データを結合したクエリと
集約済みのデータを取得した場合の性能比較を行った

---

### 比較対象

- 明細データ
- 月別精算表データ
- 年度別精算表データ

---

### 結合クエリ

#### 特徴

- Incremental Sort
- Nested Loop(マスタより情報取得時に使用)
- Parallel Index Scan
- Memoize(一部マスタで使用 / キャッシュ済みのもの)
- Index Scan(マスタより情報取得時に使用)
- Aggregate (精算表データ取得時に使用)

---

### 集約済みデータ

#### 特徴

- Index Scan(仕訳明細データ / ソート処理に使用)
- Incremental Sort(精算表データ / 少量データソート時に使用)
- Bitmap Heap Scan / Bitmap Index Scan(条件絞り込み時に使用)
- Seq Scan

---

### 相違点

Oracle 側同様に、結合クエリ側で行っていた Bitmap Scan などの分だけ、
集約済みデータ取得時は実行計画の内容は大幅にシンプルになっていた。

---

### 考察

- 仕訳明細データ全件検索では結合クエリ側は大量のインデックススキャンが発生していたが、
  照会データ側は単一のインデックススキャンで完了していた。
- 仕訳明細データを絞り込んだものでは結合クエリ側でも実行計画が効率化し、
  集約済みデータ側の効率化は限定的だった
- 精算表データ側で圧倒的にコストが削減された。
