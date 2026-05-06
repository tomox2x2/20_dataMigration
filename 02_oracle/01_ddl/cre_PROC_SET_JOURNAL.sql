create or replace procedure proc_set_journal (
    pi_frm_var in varchar2,
    pi_to_var in varchar2,
    pi_fiscal_id in varchar2
)
 is
 /* ==============================================
    物理名称: proc_set_journal 
    処理概要: 仕訳明細作成プロシージャ
        入力パラメータ: pi_frm_var 日付From 'YYYYMMDD'
                       pi_to   _var  日付To 'YYYYMMDD'
                       pi_fiscal_id 決算期コード
        出力パラメータ: なし
    更新履歴: 2026/05/07 新規作成 Tomoshige Momose
    ============================================== */

-- 変数定義
cs_proc_name constant varchar2(30) := 'proc_set_journal';

v_sql varchar2(4000);
ls_create_var varchar2(16) := to_char(sysdate, 'YYYYMMDD HH24MISS');
ls_data_cnt number;
ls_table_name varchar2(64);

li_line number := 0;

begin

dbms_output.put_line(cs_proc_name || ': start :' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

li_line := 10;

ls_table_name := 't_journal_' || pi_fiscal_id;

proc_int_trantable(pi_fiscal_id, 'T_JOURNAL');

dbms_output.put_line(cs_proc_name || ':' || li_line || ':' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

li_line := 20;

v_sql := 'insert into ' || ls_table_name || 
            ' select ' ||
            '   tj1.journal_id, ' ||
            '   tj1.company_id, ' ||
            '   m1.company_code , m1.company_name, ' ||
            '   tj1.party_id, ' ||
            '   m2.party_code , m2.party_name , ' ||
            '   tj1.journal_date, ' ||
            '   tj1.description, ' ||
            '   tj2.detail_id, ' ||
            '   tj2.line_no , ' ||
            '   tj2.account_id, ' ||
            '   m3.account_type, m3.account_code, m3.account_name, ' ||
            '   tj2.debit_amount , ' ||
            '   tj2.credit_amount , ' ||
            '   abs( COALESCE(tj2.DEBIT_AMOUNT,0) - COALESCE(tj2.CREDIT_AMOUNT,0) ), ' ||
            '   COALESCE(tj2.DEBIT_AMOUNT,0) - COALESCE(tj2.CREDIT_AMOUNT,0) , ' ||
            '   to_date(:created_at, ''YYYYMMDD HH24MISS'') ' ||
            ' from   t_journal_header tj1 ' ||
            '  inner join t_journal_detail tj2 on tj1.journal_id = tj2.journal_id ' ||
            '  inner join m_company m1 on tj1.company_id = m1.company_id ' ||
            '  inner join m_party m2 on tj1.party_id = m2.party_id ' ||
            '  inner join m_account m3 on tj2.account_id = m3.account_id ' ||
            'where journal_date >= to_date(:frm_var, ''YYYYMMDD'') ' ||
            'and   journal_date < to_date(:to_var, ''YYYYMMDD'') ';

execute immediate v_sql using ls_create_var, pi_frm_var, pi_to_var;

dbms_output.put_line(cs_proc_name || ':' || li_line || ':' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

commit;

li_line := 30;

DBMS_STATS.GATHER_TABLE_STATS('ACT1', ls_table_name, cascade => true);

dbms_output.put_line(cs_proc_name || ':' || li_line || ':' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

exception
when others then
    dbms_output.put_line('エラーが発生しました');
    dbms_output.put_line(cs_proc_name || ':' || li_line );
    dbms_output.put_line(SQLERRM(SQLCODE));

end;
/