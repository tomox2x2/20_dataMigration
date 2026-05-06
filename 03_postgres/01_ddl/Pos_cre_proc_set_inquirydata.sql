CREATE OR REPLACE PROCEDURE act1.proc_set_inquirydata(
    IN pi_fiscal_id VARCHAR
)
AS 
$BODY$
 /* ==============================================
    proc_set_inquirydata
    Process Overview:
          Main procedure for creating query data
    input : pi_fiscal_id  -- fiscal year ID
    output: none
    update record: 2026/05/17 create Tomoshige Momose
    ============================================== 
*/
DECLARE

    cs_proc_name CONSTANT VARCHAR(30) := 'proc_set_inquirydata';
    cs_sysParm_id CONSTANT INTEGER := 1001;

    ls_frm_date DATE;
    ls_to_date DATE;
    ls_data_cnt INTEGER;

    ls_fin_year CHARACTER(4);
    ls_fin_class CHARACTER(1);
    ls_fin_month CHARACTER(2);

    ls_fiscal_id CHARACTER(7);
    ls_sysParm_cnt INTEGER;
    ls_close_month_num INTEGER;

    li_line INTEGER := 0;

BEGIN

    RAISE NOTICE '%: start : %', cs_proc_name, to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    li_line := 10;

    /* Common: Edit Period */
    ls_fin_year := substr(pi_fiscal_id, 1, 4);
    ls_fin_class := substr(pi_fiscal_id, 5, 1);
    ls_fin_month := substr(pi_fiscal_id, 6, 2);

    SELECT
        COUNT(1)
        INTO STRICT ls_data_cnt
        FROM act1.m_actperiod
        WHERE fin_year = ls_fin_year 
        AND   fin_class = ls_fin_class 
        AND   fin_month = ls_fin_month;

    IF ls_data_cnt = 0 THEN
        RAISE NOTICE '%: not found fiscal period data. end process.', cs_proc_name;
        RETURN;
    END IF;

    /* Edit the period based on the fiscal year code */
    /* ls_to_date: The reason for adding one day is to include the end date of the period */
    SELECT
        start_date,  
        end_date + INTERVAL '1 day',
        lower(fin_year || fin_class || fin_month)
        INTO STRICT ls_frm_date, ls_to_date, ls_fiscal_id
    FROM act1.m_actperiod
    WHERE fin_year  = ls_fin_year 
    AND   fin_class = ls_fin_class 
    AND   fin_month = ls_fin_month;

    RAISE NOTICE '%:%:%', cs_proc_name, li_line,to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');
 
    li_line := 20;
    /* Get the number of source data records */
    SELECT
        COUNT(1)
        INTO STRICT ls_data_cnt
    FROM act1.t_journal_header
    WHERE journal_date >= ls_frm_date
    AND   journal_date <  ls_to_date;

    IF ls_data_cnt = 0 THEN
        RAISE NOTICE '%: not exists target data. end process.', cs_proc_name;
        RETURN;
    END IF;

    li_line := 21;
    
    /* Check SYS-PARAM for the fiscal year */
    SELECT
        COUNT(1)
        INTO STRICT ls_sysParm_cnt
    FROM act1.d_sysparam
    WHERE param_id = cs_sysParm_id;
    
    RAISE NOTICE '%:%:%', cs_proc_name, li_line,to_char( clock_timestamp(),'YYYY/MM/DD HH24:MI:SS');

    /* ****************************************************** */
    /* Make details */
    /* ****************************************************** */
    li_line := 30;

    /* Make Journal entry details */
    CALL act1.proc_set_journal(ls_frm_date, ls_to_date, ls_fiscal_id);

    li_line := 31;

    /* Make Monthly settlement sheet */
    CALL act1.proc_set_settl_m(ls_fiscal_id);
    
    li_line := 32;

    IF ls_sysParm_cnt != 1 THEN
        RAISE NOTICE '%: system parameter: % is not set.', cs_proc_name, cs_sysParm_id;
        RAISE NOTICE '%: fiscal year settlement table will not be created.', cs_proc_name;
        RETURN;
    END IF;

    li_line := 33;

    /* Get the closing month number */
    SELECT
        param_value::numeric
        INTO STRICT ls_close_month_num
    FROM act1.d_sysparam
    WHERE param_id = cs_sysParm_id;

    li_line := 34;

    /* Make Annual settlement sheet */
    CALL act1.proc_set_settl_y(ls_fiscal_id, ls_close_month_num);

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
