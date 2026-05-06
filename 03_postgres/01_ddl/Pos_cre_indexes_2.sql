DROP INDEX IF EXISTS act1.idx_jr_account;
DROP INDEX IF EXISTS act1.idx_jr_date;
DROP INDEX IF EXISTS act1.idx_jr_order_1;
DROP INDEX IF EXISTS act1.idx_sm_order_1;
DROP INDEX IF EXISTS act1.idx_smc_order_1;
DROP INDEX IF EXISTS act1.idx_sy_order_1;
DROP INDEX IF EXISTS act1.idx_syc_order_1;

CREATE INDEX idx_jr_account ON act1.t_journal
USING BTREE (account_id ASC);

CREATE INDEX idx_jr_date ON act1.t_journal
USING BTREE (journal_date ASC);

CREATE INDEX idx_jr_order_1 ON act1.t_journal
USING BTREE (company_id ASC, party_id ASC, journal_date ASC, journal_id ASC, line_no ASC);

CREATE INDEX idx_sm_order_1 ON act1.t_settl_m
USING BTREE (journal_date_m ASC, account_id ASC);

CREATE INDEX idx_smc_order_1 ON act1.t_settl_m_comp
USING BTREE (company_id ASC, journal_date_m ASC, account_id ASC);

CREATE INDEX idx_sy_order_1 ON act1.t_settl_y
USING BTREE (journal_date_y ASC, account_id ASC);

CREATE INDEX idx_syc_order_1 ON act1.t_settl_y_comp
USING BTREE (company_id ASC, journal_date_y ASC, account_id ASC);
