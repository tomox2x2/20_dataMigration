create or replace procedure act1.proc_set_inqCall (
    pi_fiscal_id VARCHAR -- Fiscal year code
)
AS 
$BODY$
 /* ==============================================
    proc_set_inqCall
    Process Overview:
          Main procedure for creating query data
    input : pi_fiscal_id  -- fiscal year ID
    output: none
    update record: 2026/05/17 create Tomoshige Momose
    ============================================== 
*/
DECLARE

    ls_fiscal_id_lower CHARACTER(7);

BEGIN  

    call act1.proc_set_inquirydata(pi_fiscal_id);

    ls_fiscal_id_lower := LOWER(pi_fiscal_id);

    COMMIT;

    EXECUTE format('ANALYZE %I.%I', 'act1', 't_journal_' || ls_fiscal_id_lower);
    EXECUTE format('ANALYZE %I.%I', 'act1', 't_settl_m_comp_' || ls_fiscal_id_lower);
    EXECUTE format('ANALYZE %I.%I', 'act1', 't_settl_m_' || ls_fiscal_id_lower);
    EXECUTE format('ANALYZE %I.%I', 'act1', 't_settl_y_comp_' || ls_fiscal_id_lower);
    EXECUTE format('ANALYZE %I.%I', 'act1', 't_settl_y_' || ls_fiscal_id_lower);

END;
$BODY$
LANGUAGE plpgsql;
