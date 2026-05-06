DROP TABLE act1.m_company CASCADE;

CREATE TABLE act1.m_company(
    company_id NUMERIC NOT NULL,
    company_code CHARACTER VARYING(20) NOT NULL,
    company_name CHARACTER VARYING(100) NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT (CLOCK_TIMESTAMP() AT TIME ZONE COALESCE(CURRENT_SETTING('aws_oracle_ext.tz', TRUE), 'UTC'))::TIMESTAMP(0)
)
        WITH (
        OIDS=FALSE
        );
ALTER TABLE act1.m_company ADD PRIMARY KEY (company_id);
