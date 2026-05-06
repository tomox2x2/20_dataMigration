DROP TABLE act1.t_journal CASCADE;

CREATE TABLE act1.t_journal(
    journal_id NUMERIC,
    company_id NUMERIC NOT NULL,
    company_code CHARACTER VARYING(20),
    company_name CHARACTER VARYING(100),
    party_id NUMERIC,
    party_code CHARACTER VARYING(20),
    party_name CHARACTER VARYING(100),
    journal_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    description CHARACTER VARYING(200),
    detail_id NUMERIC,
    line_no NUMERIC NOT NULL,
    account_id NUMERIC NOT NULL,
    account_type CHARACTER VARYING(20),
    account_code CHARACTER VARYING(20),
    account_name CHARACTER VARYING(100),
    debit_amount NUMERIC(15,2),
    credit_amount NUMERIC(15,2),
    amount NUMERIC(15,2),
    drcr_amount NUMERIC(15,2),
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT (CLOCK_TIMESTAMP() AT TIME ZONE COALESCE(CURRENT_SETTING('aws_oracle_ext.tz', TRUE), 'UTC'))::TIMESTAMP(0)
)
        WITH (
        OIDS=FALSE
        );
