create or replace procedure proc_set_inquirydata (
    pi_fiscal_id in varchar2 -- 決算期コード
)
 is
 /* ==============================================
    物理名称: proc_set_inquirydata
    処理概要: 照会用データ作成プロシージャ
        入力パラメータ: pi_fiscal_id 決算期コード
        出力パラメータ: なし
    更新履歴: 2026/05/07 新規作成 Tomoshige Momose
    ============================================== */

-- 変数定義
cs_proc_name constant varchar2(30) := 'proc_set_inquirydata';
cs_sysParm_id constant number := 1001;

-- 共通変数
ls_frm_var varchar2(8);
ls_to_var varchar2(8);
ls_data_cnt number;

-- 決算期情報変数
ls_fin_year char(4);
ls_fin_class char(1);
ls_fin_month char(2);

-- 年度別精算表用変数
ls_sysParm_cnt number;
ls_close_month_num number;
ls_frm_y_var varchar2(8);
ls_to_y_var varchar2(8);

li_line number;

begin

dbms_output.put_line(cs_proc_name || ': start :' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

li_line := 10;

-- 共通:期間を編集
ls_fin_year := substr(pi_fiscal_id, 1, 4);
ls_fin_class := substr(pi_fiscal_id, 5, 1);
ls_fin_month := substr(pi_fiscal_id, 6, 2);

select
 count(1) into ls_data_cnt from m_actperiod
where fin_year = ls_fin_year
and   fin_class = ls_fin_class
and   fin_month = ls_fin_month;

if ls_data_cnt = 0 then
    dbms_output.put_line('該当する決算期情報が設定されていません。処理を終了します。');
    return;
end if;

-- 決算期コードをもとに期間を編集
select
 to_char(start_date, 'YYYYMMDD'),
 to_char(end_date + 1, 'YYYYMMDD') -- 1日加算しているのは、期間の終了日を含めるため
into ls_frm_var, ls_to_var from m_actperiod
where fin_year = ls_fin_year
and   fin_class = ls_fin_class
and   fin_month = ls_fin_month;

dbms_output.put_line(cs_proc_name || ':' || li_line || ':' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

li_line := 20;

-- 作成元データ件数取得
select count(1) into ls_data_cnt from t_journal_header
where journal_date >= to_date(ls_frm_var, 'YYYYMMDD')
and   journal_date < to_date(ls_to_var, 'YYYYMMDD');

if ls_data_cnt = 0 then
    dbms_output.put_line('作成対象データが存在しません。処理を終了します。');
    return;
end if;

li_line := 21;

-- 決算月取得
select count(1) into ls_sysParm_cnt from d_sysparam
where param_id = cs_sysParm_id;

dbms_output.put_line(cs_proc_name || ':' || li_line || ':' ||to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') );

/* ****************************************************** */
/* 明細作成                                                */
/* ****************************************************** */

li_line := 30;

-- 仕訳明細作成
proc_set_journal(ls_frm_var, ls_to_var, pi_fiscal_id);

li_line := 31;

-- 月別精算表作成
proc_set_settl_m(ls_frm_var, ls_to_var, pi_fiscal_id);

li_line := 32;

if ls_sysParm_cnt != 1 then
    dbms_output.put_line('システムパラメータ：' || cs_sysParm_id || ' が設定されていません');
    dbms_output.put_line('年度別精算表は作成されません。');
    return;
end if;

li_line := 33;

-- システムパラメータから決算月を取得
select to_number(param_value) into ls_close_month_num from d_sysparam
where param_id = cs_sysParm_id;

li_line := 34;

-- 年度別精算表作成
proc_set_settl_y(ls_frm_var, ls_to_var, pi_fiscal_id, ls_close_month_num);

exception
when others then
    dbms_output.put_line('エラーが発生しました');
    dbms_output.put_line(cs_proc_name || ':' || li_line );
    dbms_output.put_line(SQLERRM(SQLCODE));
end;
/