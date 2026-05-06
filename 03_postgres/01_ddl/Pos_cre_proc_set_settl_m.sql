CREATE OR REPLACE PROCEDURE act1.proc_set_settl_m(
    IN pi_fiscal_id VARCHAR
)
AS 
$BODY$
 /* ==============================================
    proc_set_settl_m
    Process Overview:
          Create a Monthly settlement sheet
    input : pi_fiscal_id  -- fiscal year ID
    output: none
    update record: 2026/05/18 create Tomoshige Momose
    ============================================== 
*/
DECLARE

    cs_proc_name CONSTANT VARCHAR(30) := 'proc_set_settl_m';

    v_sql TEXT;

    ls_create_ts TIMESTAMP := clock_timestamp();

    ls_table_name_0 VARCHAR(64);
    ls_table_name_1 VARCHAR(64);
    ls_table_name_2 VARCHAR(64);

    li_line INTEGER := 0;

BEGIN

    RAISE NOTICE '%: start : %', cs_proc_name, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 10;

    ls_table_name_0 := 't_journal_' || pi_fiscal_id;
    ls_table_name_1 := 't_settl_m_comp_' || pi_fiscal_id;

    CALL act1.proc_int_trantable(pi_fiscal_id, 'T_SETTL_M_COMP'::TEXT);

    RAISE NOTICE '%:%:%', cs_proc_name, li_line, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 20;

    /* Create Monthly Settlement Sheet by Company */
    v_sql := format(
                $fmt$
                insert into %I.%I
                 (company_id, company_code, company_name, journal_date_m, 
                  account_id, account_type, account_code, account_name, 
                  debit_amount, credit_amount, amount, drcr_amount, 
                  created_at)
                 select 
                   company_id, 
                   company_code, 
                   company_name, 
                   date_trunc( 'MONTH', journal_date ), 
                   account_id, 
                   account_type, 
                   account_code, 
                   account_name, 
                   sum(debit_amount), 
                   sum(credit_amount), 
                   abs(sum(drcr_amount)), 
                   sum(drcr_amount), 
                   $1
                 from  %I.%I
                 group by 
                  company_id, 
                  company_code, 
                  company_name, 
                  date_trunc( 'MONTH', journal_date ), 
                  account_id,  
                  account_type,  
                  account_code,  
                  account_name
                $fmt$,
                'act1', ls_table_name_1,
                'act1', ls_table_name_0
    );

    EXECUTE v_sql USING ls_create_ts;

    RAISE NOTICE '%:%:%', cs_proc_name, li_line, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 30;

    ls_table_name_2 := 't_settl_m_' || pi_fiscal_id;

    CALL act1.proc_int_trantable(pi_fiscal_id, 'T_SETTL_M'::TEXT);
    
    RAISE NOTICE '%:%:%', cs_proc_name, li_line, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 40;

    /* Create Monthly settlement sheet */
    v_sql := format(
                $fmt$
                insert into %I.%I
                 (journal_date_m, account_id, account_type, account_code, account_name, 
                  debit_amount, credit_amount, amount, drcr_amount, 
                  created_at)
                 select 
                   journal_date_m, 
                   account_id, 
                   account_type, 
                   account_code, 
                   account_name, 
                   sum(debit_amount), 
                   sum(credit_amount), 
                   abs(sum(drcr_amount)), 
                   sum(drcr_amount), 
                   $1
                 from  %I.%I
                 group by  
                  journal_date_m,  
                  account_id,  
                  account_type,  
                  account_code,  
                  account_name
                $fmt$,
                'act1', ls_table_name_2,
                'act1', ls_table_name_1
    );

    EXECUTE v_sql USING ls_create_ts;

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
