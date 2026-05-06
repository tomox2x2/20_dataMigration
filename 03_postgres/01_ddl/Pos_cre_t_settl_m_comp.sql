DROP TABLE act1.t_settl_m_comp CASCADE;

CREATE TABLE act1.t_settl_m_comp(
    company_id NUMERIC NOT NULL,
    company_code CHARACTER VARYING(20),
    company_name CHARACTER VARYING(100),
    journal_date_m TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    account_id NUMERIC NOT NULL,
    account_type CHARACTER VARYING(20),
    account_code CHARACTER VARYING(20),
    account_name CHARACTER VARYING(100),
    debit_amount NUMERIC(18,2),
    credit_amount NUMERIC(18,2),
    amount NUMERIC(18,2),
    drcr_amount NUMERIC(18,2),
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT (CLOCK_TIMESTAMP() AT TIME ZONE COALESCE(CURRENT_SETTING('aws_oracle_ext.tz', TRUE), 'UTC'))::TIMESTAMP(0)
)
        WITH (
        OIDS=FALSE
        );
