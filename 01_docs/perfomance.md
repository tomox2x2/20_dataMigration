# ■ パフォーマンスチューニング

## ■ 方針

- WHERE句・JOIN条件を中心にインデックス設計
- カバリングインデックス活用（INCLUDE）
- SQL構造の見直し

---

## ■ ケース①：集約クエリ改善

### ■ 課題
- Bitmap Heap Scan発生
- HeapアクセスによるI/O増加

### ■ 対応
- カバリングインデックス作成
- Index Only Scan化

```sql
CREATE INDEX idx_jd_cover_1
ON act1.t_journal_detail (account_id, journal_id)
INCLUDE (debit_amount, credit_amount);
```

### 結果
- 0.225秒 → 0.069秒（70%改善）

---

## ■ ケース②：JOIN前のデータ削減

### ■ 課題
- JOIN前のデータ量が多く非効率

### ■ 対応
- 高選択度条件（JOURNAL_ID）を先に適用
- インデックス利用効率を向上

### ■ 結果
- 0.082秒 → 0.068秒（17%改善）

---

## ■ ケース③：スカラサブクエリ最適化

### ■ 課題
- 行単位でサブクエリが実行される（N回実行）

### ■ 対応
- インデックス追加
- 並列実行設定

### ■ 結果
- 0.674秒 → 0.556秒（17%改善）

## ■ 重要な知見
- PostgreSQLはヒント句が存在しない
- Index Only ScanはVisibility Mapに依存
- VACUUM / ANALYZEが重要
- 統計情報により実行計画が変化

## ■ 今後の改善案
- JOIN + GROUP BYへの書き換え
- パーティショニング、マテリアライズドビュー活用した改善
- 照会用データ作成による改善
