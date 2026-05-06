CREATE OR REPLACE PROCEDURE act1.proc_set_journal(
    IN pi_frm_date DATE, 
    IN pi_to_date DATE, 
    IN pi_fiscal_id VARCHAR
)
AS 
$BODY$
 /* ==============================================
    proc_set_journal
    Process Overview:
          Create a journal entry statement
    input : pi_frm_date    -- start date
            pi_to_date     -- end date
            pi_fiscal_id  -- fiscal year ID
    output: none
    update record: 2026/05/17 create Tomoshige Momose
    ============================================== 
*/
DECLARE

    cs_proc_name CONSTANT VARCHAR(30) := 'proc_set_journal';

    v_sql TEXT;

    ls_create_ts TIMESTAMP := clock_timestamp();

    ls_data_cnt INTEGER;
    ls_table_name VARCHAR(64);

    li_line INTEGER := 0;

BEGIN

    RAISE NOTICE '%: start : %', cs_proc_name, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 10;

    ls_table_name := 't_journal_' || pi_fiscal_id;
    CALL act1.proc_int_trantable(pi_fiscal_id, 'T_JOURNAL'::TEXT);

    RAISE NOTICE '%:%:%', cs_proc_name, li_line,to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');
 
    li_line := 20;

    v_sql := format(
            $fmt$   
            insert into %I.%I
             (journal_id, company_id, company_code, company_name, 
              party_id, party_code, party_name, 
              journal_date, description, detail_id, line_no, 
              account_id, account_type, account_code, account_name, 
              debit_amount, credit_amount, amount, drcr_amount, 
              created_at)
                select 
                    tj1.journal_id, 
                    tj1.company_id, 
                    m1.company_code , m1.company_name, 
                    tj1.party_id, 
                    m2.party_code , m2.party_name , 
                    tj1.journal_date, 
                    tj1.description, 
                    tj2.detail_id, 
                    tj2.line_no , 
                    tj2.account_id, 
                    m3.account_type, m3.account_code, m3.account_name, 
                    tj2.debit_amount , 
                    tj2.credit_amount , 
                    abs( COALESCE(tj2.DEBIT_AMOUNT,0) - COALESCE(tj2.CREDIT_AMOUNT,0) ), 
                    COALESCE(tj2.DEBIT_AMOUNT,0) - COALESCE(tj2.CREDIT_AMOUNT,0) , 
                    $1::TIMESTAMP
                from   act1.t_journal_header tj1 
                inner join act1.t_journal_detail tj2 on tj1.journal_id = tj2.journal_id 
                inner join act1.m_company m1 on tj1.company_id = m1.company_id 
                inner join act1.m_party m2   on tj1.party_id   = m2.party_id 
                inner join act1.m_account m3 on tj2.account_id = m3.account_id 
                where journal_date >= $2 
                and   journal_date <  $3 
            $fmt$, 
            'act1', ls_table_name
        );

    EXECUTE v_sql USING ls_create_ts, pi_frm_date, pi_to_date;
    RAISE NOTICE '%:%:%', cs_proc_name, li_line,to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 30;

    RAISE NOTICE '%:%:%', cs_proc_name, li_line, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    EXCEPTION
        WHEN others THEN
            RAISE NOTICE '%: An error has occurred', cs_proc_name;
            RAISE NOTICE '%: %', cs_proc_name, li_line;
            RAISE NOTICE '%: %', cs_proc_name, SQLERRM;
            RAISE;
END;
$BODY$
LANGUAGE plpgsql;
