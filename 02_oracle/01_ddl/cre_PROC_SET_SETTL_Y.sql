create or replace procedure proc_set_settl_y(
    pi_frm_y_var in varchar2 ,
    pi_to_y_var in varchar2 ,
    pi_fiscal_id in varchar2 ,
    pi_close_month_num in number
)
 is
 /* ==============================================
    物理名称: proc_set_settl_y
    処理概要: 年度別精算表作成プロシージャ
        入力パラメータ: pi_frm_y_var 日付From 'YYYYMMDD'
                       pi_to_y_var  日付To 'YYYYMMDD'
                       pi_fiscal_id 決算期コード
                       pi_close_month_num 決算月
        出力パラメータ: なし
    更新履歴: 2026/05/07 新規作成 Tomoshige Momose
    ============================================== */

-- 変数定義
cs_proc_name constant varchar2(30) := 'proc_set_settl_y';

v_sql varchar2(4000);
ls_create_var varchar2(16) := to_char(sysdate, 'YYYYMMDD HH24MISS');
ls_table_name_0 varchar2(64);
ls_table_name_1 varchar2(64);
ls_table_name_2 varchar2(64);

li_line number;

begin

dbms_output.put_line(cs_proc_name || ': start :' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

li_line := 10;

ls_table_name_0 := 'T_SETTL_M_COMP_' || pi_fiscal_id;
ls_table_name_1 := 'T_SETTL_Y_COMP_' || pi_fiscal_id;

proc_int_trantable(pi_fiscal_id, 'T_SETTL_Y_COMP');

dbms_output.put_line(cs_proc_name || ':' || li_line || ':' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

li_line := 20;

-- 年度・会社別精算表作成
v_sql := 'insert into ' || ls_table_name_1 || 
            ' select ' ||
            '   company_id, ' ||
            '   company_code, ' ||
            '   company_name, ' ||
            '   trunc(to_date ' ||
            '     (to_char(add_months(journal_date_m, (:close_month * -1) ), ''YYYY'') || ' || 
            '      to_char(to_number(:close_month) + 1,''00'') , ''YYYYMM'')), ' ||
            '   account_id, ' ||
            '   account_type, ' ||
            '   account_code, ' ||
            '   account_name, ' ||
            '   sum(debit_amount), ' ||
            '   sum(credit_amount), ' ||
            '   abs(sum(drcr_amount)), ' ||
            '   sum(drcr_amount), ' ||
            '   to_date(:created_at, ''YYYYMMDD HH24MISS'') ' ||
            ' from  ' || ls_table_name_0 || 
            ' where journal_date_m >= to_date(:frm_dt, ''YYYYMMDD'') ' ||
            ' and   journal_date_m < to_date(:to_dt, ''YYYYMMDD'') ' ||
            ' group by ' ||
            '  company_id, ' || 
            '  company_code, ' || 
            '  company_name, ' || 
            '   trunc(to_date ' ||
            '     (to_char(add_months(journal_date_m, (:close_month * -1) ), ''YYYY'') || ' || 
            '      to_char(to_number(:close_month) + 1,''00'') , ''YYYYMM'')), ' ||
            '  account_id, ' || 
            '  account_type, ' || 
            '  account_code, ' || 
            '  account_name ';

execute immediate v_sql 
using pi_close_month_num, 
      pi_close_month_num, 
      ls_create_var, 
      pi_frm_y_var, 
      pi_to_y_var,
      pi_close_month_num, 
      pi_close_month_num;

dbms_output.put_line(cs_proc_name || ':' || li_line || ':' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

li_line := 30;

ls_table_name_2 := 'T_SETTL_Y_' || pi_fiscal_id;
proc_int_trantable(pi_fiscal_id, 'T_SETTL_Y');

dbms_output.put_line(cs_proc_name || ':' || li_line || ':' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

li_line := 40;

-- 年度精算表作成
v_sql := 'insert into ' || ls_table_name_2 || 
            ' select ' ||
            '   journal_date_y, ' ||
            '   account_id, ' ||
            '   account_type, ' ||
            '   account_code, ' ||
            '   account_name, ' ||
            '   sum(debit_amount), ' ||
            '   sum(credit_amount), ' ||
            '   abs(sum(drcr_amount)), ' ||
            '   sum(drcr_amount), ' ||
            '   to_date(:created_at, ''YYYYMMDD HH24MISS'') ' ||
            ' from  ' || ls_table_name_1 || 
            ' where journal_date_y >= to_date(:frm_dt, ''YYYYMMDD'') ' ||
            ' and   journal_date_y < to_date(:to_dt, ''YYYYMMDD'') ' ||
            ' group by ' ||
            '  journal_date_y, ' || 
            '  account_id, ' || 
            '  account_type, ' || 
            '  account_code, ' || 
            '  account_name ';

execute immediate v_sql using ls_create_var, pi_frm_y_var, pi_to_y_var;

dbms_output.put_line(cs_proc_name || ':' || li_line || ':' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

commit;

li_line := 50;

DBMS_STATS.GATHER_TABLE_STATS('ACT1', ls_table_name_1, cascade => true);
DBMS_STATS.GATHER_TABLE_STATS('ACT1', ls_table_name_2, cascade => true);

dbms_output.put_line(cs_proc_name || ':' || li_line || ':' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

exception
when others then
    dbms_output.put_line('エラーが発生しました');
    dbms_output.put_line(cs_proc_name || ':' || li_line );
    dbms_output.put_line(SQLERRM(SQLCODE));

end;
/