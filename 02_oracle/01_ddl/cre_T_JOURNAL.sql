DROP TABLE t_journal CASCADE CONSTRAINT PURGE;

CREATE TABLE t_journal (
    journal_id     NUMBER,
    company_id     NUMBER NOT NULL,
    company_code   VARCHAR2(20),
    company_name   VARCHAR2(100),
    party_id       NUMBER,
    party_code     VARCHAR2(20),
    party_name     VARCHAR2(100),
    journal_date   DATE NOT NULL,
    description    VARCHAR2(200),
    detail_id      NUMBER,
    line_no        NUMBER NOT NULL,
    account_id     NUMBER NOT NULL,
    account_type   VARCHAR2(20),
    account_code   VARCHAR2(20),
    account_name   VARCHAR2(100),
    debit_amount   NUMBER(15,2),
    credit_amount  NUMBER(15,2),
    amount         NUMBER(15,2),
    drcr_amount    NUMBER(15,2),
    created_at     DATE DEFAULT SYSDATE
) TABLESPACE trn_act1;

CREATE INDEX idx_jr_order_1 ON t_journal (
    company_id,
    party_id,
    journal_date,
    journal_id,
    line_no
) TABLESPACE idx_act1;

CREATE INDEX idx_jr_date ON t_journal (
    journal_date
) TABLESPACE idx_act1;
