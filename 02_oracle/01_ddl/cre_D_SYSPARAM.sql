DROP TABLE d_sysparam CASCADE CONSTRAINT PURGE;

CREATE TABLE d_sysparam (
    param_id       NUMBER PRIMARY KEY,
    param_name     VARCHAR2(100) NOT NULL,
    param_value    VARCHAR2(200),
    description    VARCHAR2(200),
    created_at     DATE DEFAULT SYSDATE
) TABLESPACE trn_act1;

