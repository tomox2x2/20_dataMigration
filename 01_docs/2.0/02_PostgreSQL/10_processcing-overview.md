# 照会用データ作成処理（PostgreSQL版）概要

## 1. 概要

本処理は、会計仕訳データをもとに、
照会用および精算表用の集計データを作成する
PostgreSQL PL/pgSQL バッチ処理です。

Oracle版と同様に、決算期単位で
照会用トランザクションテーブルを動的生成します。

統計情報更新には PostgreSQL の ANALYZE を利用します。

---

## 2. 主な機能

- 仕訳明細データ作成
- 月別精算表作成
- 年度別精算表作成
- 動的テーブル生成
- 動的インデックス生成
- 統計情報更新（ANALYZE）

---

## 3. 入力パラメータ

| パラメータ | 内容 |
|---|---|
| pi_fiscal_id | 決算期コード |

### 入力例

```text
20251003
```

### 決算期コード構成

| 桁 | 内容 |
|---|---|
|1～4桁|年度|
|5桁|決算区分|
|6～7桁|決算月|

---

## 4. 作成テーブル

| テーブル | 内容 |
|---|---|
|T_JOURNAL_XXX|仕訳明細照会|
|T_SETTL_M_COMP_XXX|月別会社別精算表|
|T_SETTL_M_XXX|月別精算表|
|T_SETTL_Y_COMP_XXX|年度別会社別精算表|
|T_SETTL_Y_XXX|年度別精算表|

※ XXXには決算期コードを付与する。

---

## 5. メイン処理

メイン制御プロシージャ

```
proc_set_inqCall
    └─ proc_set_inquirydata
```

proc_set_inqCall は集計処理実行後に
各生成テーブルに対して ANALYZE を実施する。

---

## 6. 主な使用技術

### PostgreSQL

- PL/pgSQL
- ANALYZE
- RAISE NOTICE
- format()
- EXECUTE

### SQL

- CREATE TABLE AS
- 動的SQL
- FOR LOOP
