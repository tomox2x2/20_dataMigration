DROP TABLE t_settl_y_comp CASCADE CONSTRAINT PURGE;

CREATE TABLE t_settl_y_comp (
    company_id     NUMBER NOT NULL,
    company_code   VARCHAR2(20),
    company_name   VARCHAR2(100),
    journal_date_y   DATE NOT NULL,
    account_id     NUMBER NOT NULL,
    account_type   VARCHAR2(20),
    account_code   VARCHAR2(20),
    account_name   VARCHAR2(100),
    debit_amount   NUMBER(18,2),
    credit_amount  NUMBER(18,2),
    amount         NUMBER(18,2),
    drcr_amount    NUMBER(18,2),
    created_at     DATE DEFAULT SYSDATE
) TABLESPACE trn_act1;

CREATE INDEX idx_syc_order_1 ON t_settl_y_comp (
    company_id,
    journal_date_y,
    account_id
) TABLESPACE idx_act1;
