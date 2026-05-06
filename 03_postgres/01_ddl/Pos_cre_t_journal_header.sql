CREATE TABLE act1.t_journal_header(
    journal_id NUMERIC NOT NULL,
    company_id NUMERIC NOT NULL,
    party_id NUMERIC,
    journal_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    description CHARACTER VARYING(200),
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT (CLOCK_TIMESTAMP() AT TIME ZONE COALESCE(CURRENT_SETTING('aws_oracle_ext.tz', TRUE), 'UTC'))::TIMESTAMP(0)
)
        WITH (
        OIDS=FALSE
        );

ALTER TABLE act1.t_journal_header ADD PRIMARY KEY (journal_id);

ALTER TABLE act1.t_journal_header
ADD CONSTRAINT fk_jh_company FOREIGN KEY (company_id) 
REFERENCES act1.m_company (company_id)
ON DELETE NO ACTION;

ALTER TABLE act1.t_journal_header
ADD CONSTRAINT fk_jh_party FOREIGN KEY (party_id) 
REFERENCES act1.m_party (party_id)
ON DELETE NO ACTION;