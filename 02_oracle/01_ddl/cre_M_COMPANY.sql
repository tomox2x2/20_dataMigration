DROP TABLE m_company CASCADE CONSTRAINT PURGE;

CREATE TABLE m_company (
    company_id     NUMBER PRIMARY KEY,
    company_code   VARCHAR2(20) NOT NULL,
    company_name   VARCHAR2(100) NOT NULL,
    created_at     DATE DEFAULT SYSDATE
)  TABLESPACE trn_act1;
