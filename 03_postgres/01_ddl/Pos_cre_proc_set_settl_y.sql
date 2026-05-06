CREATE OR REPLACE PROCEDURE act1.proc_set_settl_y(
    IN pi_fiscal_id VARCHAR, 
    IN pi_close_month_num INTEGER)
AS 
$BODY$
 /* ==============================================
    proc_set_settl_y
    Process Overview:
          Create a Yearly settlement sheet
    input : pi_fiscal_id  -- fiscal year ID
            pi_close_month_num -- closing month number
    output: none
    update record: 2026/05/18 create Tomoshige Momose
    ============================================== 
*/
DECLARE

    cs_proc_name CONSTANT VARCHAR(30) := 'proc_set_settl_y';

    v_sql TEXT;

    ls_create_ts TIMESTAMP := clock_timestamp();

    ls_table_name_0 VARCHAR(64);
    ls_table_name_1 VARCHAR(64);
    ls_table_name_2 VARCHAR(64);

    li_line INTEGER := 0;
BEGIN

    RAISE NOTICE '%: start : %', cs_proc_name, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 10;

    ls_table_name_0 := 't_settl_m_comp_' || pi_fiscal_id;
    ls_table_name_1 := 't_settl_y_comp_' || pi_fiscal_id;

    CALL act1.proc_int_trantable(pi_fiscal_id, 'T_SETTL_Y_COMP'::TEXT);
    RAISE NOTICE '%: % : %', cs_proc_name, li_line, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 20;

    /* Create Yearly settlement sheet by Company */
    v_sql := format(
                $fmt$
                insert into %I.%I
                 (company_id, company_code, company_name, journal_date_y, 
                  account_id, account_type, account_code, account_name, 
                  debit_amount, credit_amount, amount, drcr_amount, 
                  created_at)
                 select 
                   company_id, 
                   company_code, 
                   company_name, 
                   to_date 
                        (to_char(journal_date_m - interval %L month, 'YYYY') || 
                         to_char($1 + 1,'00') , 'YYYYMM'), 
                   account_id, 
                   account_type, 
                   account_code, 
                   account_name, 
                   sum(debit_amount), 
                   sum(credit_amount), 
                   abs(sum(drcr_amount)), 
                   sum(drcr_amount), 
                   $2 
                  from  %I.%I
                  group by  
                    company_id,  
                    company_code,  
                    company_name,  
                    to_date 
                         (to_char(journal_date_m - interval %L month, 'YYYY') || 
                          to_char($1 + 1,'00') , 'YYYYMM'), 
                    account_id,  
                    account_type,  
                    account_code,  
                    account_name
                $fmt$, 
                'act1', ls_table_name_1, 
                pi_close_month_num, 
                'act1', ls_table_name_0,
                pi_close_month_num
            ); 

    EXECUTE v_sql 
    USING pi_close_month_num,  
          ls_create_ts;

    RAISE NOTICE '%: % : %', cs_proc_name, li_line, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 30;

    ls_table_name_2 := 't_settl_y_' || pi_fiscal_id;

    CALL act1.proc_int_trantable(pi_fiscal_id, 'T_SETTL_Y'::TEXT);

    RAISE NOTICE '%: % : %', cs_proc_name, li_line, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 40;

    /* Create Yearly settlement sheet */
    v_sql := format(
                $fmt$
                insert into %I.%I
                 (journal_date_y, account_id, account_type, account_code, account_name, 
                  debit_amount, credit_amount, amount, drcr_amount, 
                  created_at)
                 select 
                   journal_date_y, 
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
                  journal_date_y,  
                  account_id,  
                  account_type,  
                  account_code,  
                  account_name
                $fmt$,
                'act1', ls_table_name_2,
                'act1', ls_table_name_1
            );

    EXECUTE v_sql USING ls_create_ts;

    RAISE NOTICE '%: % : %', cs_proc_name, li_line, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    EXCEPTION
        WHEN others THEN
            RAISE NOTICE '%: An error has occurred', cs_proc_name;
            RAISE NOTICE '%: %', cs_proc_name, li_line;
            RAISE NOTICE '%: %', cs_proc_name, SQLERRM;
            RAISE;
END;
$BODY$
LANGUAGE plpgsql;

