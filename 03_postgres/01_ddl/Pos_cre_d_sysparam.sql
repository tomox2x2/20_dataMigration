DROP TABLE act1.d_sysparam CASCADE;

CREATE TABLE act1.d_sysparam(
    param_id NUMERIC NOT NULL,
    param_name CHARACTER VARYING(100) NOT NULL,
    param_value CHARACTER VARYING(200),
    description CHARACTER VARYING(200),
    created_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT (CLOCK_TIMESTAMP() AT TIME ZONE COALESCE(CURRENT_SETTING('aws_oracle_ext.tz', TRUE), 'UTC'))::TIMESTAMP(0)
)
        WITH (
        OIDS=FALSE
        );

ALTER TABLE act1.d_sysparam
ADD PRIMARY KEY (param_id);
