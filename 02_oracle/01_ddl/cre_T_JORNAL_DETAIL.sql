DROP TABLE t_journal_detail CASCADE CONSTRAINT PURGE;

CREATE TABLE t_journal_detail (
    detail_id      NUMBER PRIMARY KEY,
    journal_id     NUMBER NOT NULL,
    line_no        NUMBER NOT NULL,
    account_id     NUMBER NOT NULL,
    debit_amount   NUMBER(15,2),
    credit_amount  NUMBER(15,2),
    created_at     DATE DEFAULT SYSDATE,
    CONSTRAINT fk_jd_journal FOREIGN KEY (journal_id)
        REFERENCES t_journal_header(journal_id),
    CONSTRAINT fk_jd_account FOREIGN KEY (account_id)
        REFERENCES m_account(account_id)
)  TABLESPACE trn_act1;

CREATE INDEX idx_jd_journal ON t_journal_detail(journal_id) TABLESPACE idx_act1;
CREATE INDEX idx_jd_account ON t_journal_detail(account_id) TABLESPACE idx_act1;
CREATE INDEX idx_jd_journal_account ON journal_detail(journal_id, account_id) TABLESPACE idx_act1;