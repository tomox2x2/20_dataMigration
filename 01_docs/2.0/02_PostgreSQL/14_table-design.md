# テーブル設計

## 1. 元テーブル

| テーブル | 内容 |
|---|---|
| T_JOURNAL_HEADER | 仕訳ヘッダ |
| T_JOURNAL_DETAIL | 仕訳明細 |
| M_COMPANY | 会社マスタ |
| M_PARTY | 取引先マスタ |
| M_ACCOUNT | 勘定科目マスタ |
| M_ACTPERIOD | 決算期マスタ |
| D_SYSPARAM | システムパラメータ |

---

## 2. 作成テーブル

### T_JOURNAL_*

仕訳明細照会用テーブル。
仕訳ヘッダ + 仕訳明細 + マスタの属性値付与したもの

---

### T_SETTL_M_COMP_*

月別会社別精算表。
月 / 会社 / 勘定科目単位の精算表。

---

### T_SETTL_M_*

月別精算表。
月 / 勘定科目単位の精算表。

---

### T_SETTL_Y_COMP_*

年度別会社別精算表。
年度 / 会社 / 勘定科目単位の精算表。


---

### T_SETTL_Y_*

年度別精算表。
年度 / 勘定科目単位の精算表。

---

## 3. テーブル関連図

```text
T_JOURNAL_HEADER
        +
T_JOURNAL_DETAIL
        +
Master Tables
        |
        v
+------------------+
| T_JOURNAL_xxx    |
+------------------+
        |
        v
+----------------------+
| T_SETTL_M_COMP_xxx   |
+----------------------+
        |
        +-----> T_SETTL_M_xxx
        |
        v
+----------------------+
| T_SETTL_Y_COMP_xxx   |
+----------------------+
        |
        +-----> T_SETTL_Y_xxx
```

---

## 4. PostgreSQL でのテーブル生成方式

以下のクエリでコピーを行う。
```sql
CREATE TABLE AS SELECT * FROM BaseTable WHERE 1=0
```

インデックスは pg_indexes から取得したDDLを利用して作成する。
