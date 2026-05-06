# 処理フロー

## 1. 全体処理フロー

```text
proc_set_inqCall
 │
proc_set_inquirydata
 ├── (1)決算期チェック
 ├── (2)元データ存在チェック
 ├── (3)proc_set_journal
 │    └── proc_int_trantable
 ├── (4)proc_set_settl_m
 │    └── proc_int_trantable
 └── (5)proc_set_settl_y
      └── proc_int_trantable
```

## 2. 処理シーケンス

### (1) 決算期チェック
 - 決算期マスタ存在確認
 - 対象期間取得

対象テーブル：M_ACTPERIOD

### (2) 元データ存在チェック
 - 対象期間内の仕訳データ存在確認を行う。

対象テーブル:T_JOURNAL_HEADER

### (3) proc_set_journal(仕訳明細作成処理)
 - 動的テーブル初期化(proc_int_tantable)
 - 仕訳明細データ作成

取得元テーブル:T_JOURNAL_HEADER, T_JOURNAL_DETAIL etc

### (4) proc_set_settl_m(月別精算表作成処理)
 - 動的テーブル初期化(proc_int_tantable)
 - 月別会社別精算表, 月別精算表データ作成

取得元テーブル:T_JOURNAL_XXX

### (5) proc_set_settl_m(年度別精算表作成処理)
 - 動的テーブル初期化(proc_int_tantable)
 - 年度別会社別精算表, 年度別精算表データ作成

取得元テーブル:T_SETTL_M_COMP_XXX

### (6) proc_set_inqCall での後処理
 - commit -> 統計情報取得

## 3. エラーハンドリング
以下のエラーを検知する。

| 内容           | 処理       |
| ------------ | -------- |
| 決算期未存在       | 処理終了     |
| 元データ未存在      | 処理終了     |
| システムパラメータ未設定 | 年度処理スキップ |
| 動的SQL失敗      | エラーログ出力  |
| インデックス生成失敗   | エラーログ出力  |
| その他エラー   | エラーログ出力  |

## 4. ログ出力
各処理ポイントでは以下の内容を「RAISE NOTICE」で
標準出力にログを出力する。

出力内容：
 - プロシージャ名, 実行位置, 実行時刻
 - (エラーが発生した場合) エラー内容

