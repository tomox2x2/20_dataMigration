DROP INDEX IF EXISTS act1.idx_jd_journal;
DROP INDEX IF EXISTS act1.idx_jd_account;
DROP INDEX IF EXISTS act1.idx_jd_journal_account;
DROP INDEX IF EXISTS act1.idx_jd_cover_1;
DROP INDEX IF EXISTS act1.idx_jd_order_1;
DROP INDEX IF EXISTS act1.idx_jh_company;
DROP INDEX IF EXISTS act1.idx_jh_cover_1;
DROP INDEX IF EXISTS act1.idx_jh_date;
DROP INDEX IF EXISTS act1.idx_jh_order_1;

CREATE INDEX idx_jd_journal ON act1.t_journal_detail
USING btree (journal_id ASC NULLS LAST);

CREATE INDEX idx_jd_account ON act1.t_journal_detail
USING btree (account_id ASC NULLS LAST);

CREATE INDEX idx_jd_journal_account ON act1.t_journal_detail
USING btree (journal_id ASC NULLS LAST, account_id ASC NULLS LAST);

CREATE INDEX idx_jd_cover_1 ON act1.t_journal_detail
USING btree (account_id ASC NULLS LAST, journal_id ASC NULLS LAST) INCLUDE(debit_amount, credit_amount);

CREATE INDEX idx_jd_order_1 ON act1.t_journal_detail
USING btree (journal_id ASC NULLS LAST, line_no ASC NULLS LAST);

CREATE INDEX idx_jh_company ON act1.t_journal_header
USING btree (company_id ASC NULLS LAST);

CREATE INDEX idx_jh_cover_1 ON act1.t_journal_header
USING btree (journal_date ASC NULLS LAST, journal_id ASC NULLS LAST);

CREATE INDEX idx_jh_date ON act1.t_journal_header
USING btree (journal_date ASC NULLS LAST);

CREATE INDEX idx_jh_order_1 ON act1.t_journal_header
USING btree (company_id ASC NULLS LAST, party_id ASC NULLS LAST, journal_date ASC NULLS LAST, journal_id ASC NULLS LAST);