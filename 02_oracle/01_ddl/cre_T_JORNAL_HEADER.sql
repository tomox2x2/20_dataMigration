DROP TABLE t_journal_header CASCADE CONSTRAINT PURGE;

CREATE TABLE t_journal_header (
    journal_id     NUMBER PRIMARY KEY,
    company_id     NUMBER NOT NULL,
    party_id       NUMBER,
    journal_date   DATE NOT NULL,
    description    VARCHAR2(200),
    created_at     DATE DEFAULT SYSDATE,
    CONSTRAINT fk_jh_company FOREIGN KEY (company_id)
        REFERENCES M_COMPANY(company_id),
    CONSTRAINT fk_jh_party FOREIGN KEY (party_id)
        REFERENCES M_PARTY(party_id)
) TABLESPACE trn_act1;

CREATE INDEX idx_jh_company ON t_journal_header(company_id) TABLESPACE idx_act1;
CREATE INDEX idx_jh_date ON t_journal_header(journal_date) TABLESPACE idx_act1;
