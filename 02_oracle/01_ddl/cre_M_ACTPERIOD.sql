DROP TABLE m_actperiod CASCADE CONSTRAINT PURGE;

CREATE TABLE m_actperiod (
    fin_year       CHAR(4) NOT NULL, -- 年 (例: 2024)
    fin_class      CHAR(1) NOT NULL, -- 決算区分(0:年次, 1:月次, 3:四半期, 6:半期)
    fin_month      CHAR(2) NOT NULL, -- 月 (例: 01, 02, ..., 12)
    start_date     DATE NOT NULL,
    end_date       DATE NOT NULL,
    created_at     DATE DEFAULT SYSDATE
) TABLESPACE trn_act1;