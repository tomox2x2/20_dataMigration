DROP TABLE m_account CASCADE CONSTRAINT PURGE;

CREATE TABLE m_account (
    account_id     NUMBER PRIMARY KEY,
    account_code   VARCHAR2(20) NOT NULL,
    account_name   VARCHAR2(100) NOT NULL,
    account_type   VARCHAR2(20), -- ASSET / LIABILITY / EXPENSE など
    created_at     DATE DEFAULT SYSDATE
) TABLESPACE trn_act1;
