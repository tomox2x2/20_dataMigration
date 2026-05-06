CREATE INDEX idx_jd_cover_1
ON act1.t_journal_detail (account_id, journal_id)
INCLUDE (debit_amount, credit_amount);

CREATE INDEX idx_jh_cover_1
ON act1.t_journal_header (journal_date, journal_id);

CREATE INDEX idx_jh_order_1
ON act1.t_journal_header
(company_id, party_id, journal_date, journal_id);

CREATE INDEX idx_jd_order_1
ON act1.t_journal_detail
(journal_id, line_no);
