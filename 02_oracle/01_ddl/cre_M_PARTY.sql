DROP TABLE m_party CASCADE CONSTRAINT PURGE;

CREATE TABLE m_party (
    party_id       NUMBER PRIMARY KEY,
    party_code     VARCHAR2(20) NOT NULL,
    party_name     VARCHAR2(100) NOT NULL,
    created_at     DATE DEFAULT SYSDATE
) TABLESPACE trn_act1;
