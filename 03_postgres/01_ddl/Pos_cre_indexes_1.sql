CREATE INDEX idx_jd_journal ON act1.t_journal_detail
USING BTREE (journal_id ASC);

CREATE INDEX idx_jd_account ON act1.t_journal_detail
USING BTREE (account_id ASC);

CREATE INDEX idx_jd_journal_account ON act1.t_journal_detail
USING BTREE (journal_id ASC, account_id ASC);

CREATE INDEX idx_jh_company ON act1.t_journal_header
USING BTREE (company_id ASC);

CREATE INDEX idx_jh_date ON act1.t_journal_header
USING BTREE (journal_date ASC);
