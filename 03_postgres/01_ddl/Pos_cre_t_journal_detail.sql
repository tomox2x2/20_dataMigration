DROP TABLE act1.t_journal_detail CASCADE;

CREATE TABLE act1.t_journal_detail(
    detail_id NUMERIC NOT NULL,
    journal_id NUMERIC NOT NULL,
    line_no NUMERIC NOT NULL,
    account_id NUMERIC NOT NULL,
    debit_amount NUMERIC(15,2),
    credit_amount NUMERIC(15,2),
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT (CLOCK_TIMESTAMP() AT TIME ZONE COALESCE(CURRENT_SETTING('aws_oracle_ext.tz', TRUE), 'UTC'))::TIMESTAMP(0)
)
        WITH (
        OIDS=FALSE
        );

ALTER TABLE act1.t_journal_detail ADD PRIMARY KEY (detail_id);

ALTER TABLE act1.t_journal_detail
ADD CONSTRAINT fk_jd_journal FOREIGN KEY (journal_id) 
REFERENCES act1.t_journal_header (journal_id)
ON DELETE NO ACTION;

ALTER TABLE act1.t_journal_detail
ADD CONSTRAINT fk_jd_account FOREIGN KEY (account_id) 
REFERENCES act1.m_account (account_id)
ON DELETE NO ACTION;

ALTER TABLE act1.t_journal_detail
ADD CONSTRAINT chk_amount CHECK ((debit_amount IS NOT NULL AND credit_amount IS NULL) OR (debit_amount IS NULL AND credit_amount IS NOT NULL));
