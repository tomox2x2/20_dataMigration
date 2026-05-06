DROP TABLE act1.m_account CASCADE;

CREATE TABLE act1.m_account(
    account_id NUMERIC NOT NULL,
    account_code CHARACTER VARYING(20) NOT NULL,
    account_name CHARACTER VARYING(100) NOT NULL,
    account_type CHARACTER VARYING(20),
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT (CLOCK_TIMESTAMP() AT TIME ZONE COALESCE(CURRENT_SETTING('aws_oracle_ext.tz', TRUE), 'UTC'))::TIMESTAMP(0)
)
        WITH (
        OIDS=FALSE
        );

ALTER TABLE act1.m_account ADD PRIMARY KEY (account_id);