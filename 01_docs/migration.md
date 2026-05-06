# ■ データベース移行手順

## ■ 概要

OracleからPostgreSQLへの移行は、
「スキーマ変換」と「データ移行」を分離して実施した。

---

## ■ 移行フロー

1. Oracle環境構築（Docker）
2. データ生成（Python）
3. スキーマ変換（AWS SCT）
4. 移行データ作成（Ora2Pg）
5. PostgreSQLへのデータロード（psql）

---

## ■ スキーマ変換

### ■ 使用ツール
- AWS Schema Conversion Tool（SCT）

### ■ 内容
- DDL自動生成
- データ型変換
- 関数変換

---

## ■ 移行データ作成

### ■ 使用ツール
- Ora2Pg

### ■ 手順

```bash
docker run --rm \
  -v /path/to/work:/data \
  georgmoser/ora2pg \
  ora2pg -c /data/ora2pg.conf
```

COPY文を生成
⇒ PostgreSQL形式に変換(修正)

## ■ PostgreSQLへのデータロード

### ■ 使用ツール
- psql

### ■ 手順

```bash
psql -h <host> -p 5432 -U <user> -d <db> -f <移行用SQLファイルパス>
```

---

## ■ 工夫ポイント
- スキーマ変換とデータ移行を分離
- COPY文を利用し高速ロード
- スキーマ名を明示しエラー回避

---

## ■ 移行時の注意点
- データ型差異（NUMBER → NUMERIC）
- 日付型の扱い（DATE → TIMESTAMP）

---

## ■ 移行結果
- データ移行件数：約100万件
- データ整合性問題なし
