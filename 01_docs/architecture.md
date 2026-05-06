# ■ アーキテクチャ構成

## ■ 概要

本PoCでは、Oracle環境からPostgreSQL環境への移行および性能検証を目的とし、
ローカル（Docker）およびクラウド（AWS RDS想定）の構成で検証を実施した。

---

## ■ 移行前（As-Is）

- Oracle XE（Dockerコンテナ）
- ローカル環境上で稼働
- 単一DB構成

### ■ 特徴
- 手軽に検証可能
- 本番環境を想定しない軽量構成

---

## ■ 移行後（To-Be）

- PostgreSQL（AWS RDS）
- AWS環境（VPC / Security Group）
- クラウド前提構成

### ■ 特徴
- マネージドDB（RDS）による運用負荷軽減
- スケーラビリティ向上
- OSSによるライセンスコスト削減

---

## ■ 構成イメージ

### ■ As-Is
[Client]
→ 
[Oracle XE (Docker)]
→ 
[Local Environment]

### ■ To-Be
[Client]
→ 
[psql]
→ 
[VPC / Security Group]
→ 
[PostgreSQL (AWS RDS)]

---

## ■ 使用技術

- DB：Oracle / PostgreSQL
- 環境：Docker / AWS RDS
- ネットワーク：VPC / Security Group
- ツール：AWS SCT / Ora2Pg / psql

---

## ■ 設計方針

- データ整合性を最優先
- OSS移行によるコスト削減
- クラウド移行を前提とした構成
