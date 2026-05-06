create or replace procedure proc_int_trantable (
    pi_fiscal_id in varchar2,
    pi_table_name in varchar2
)
 is
 /* ==============================================
    物理名称: proc_int_trantable
    処理概要: トランザクションテーブル初期化・作成プロシージャ
        入力パラメータ: pi_fiscal_id 決算期コード
                       pi_table_name 作成するテーブル名
        出力パラメータ: なし
    更新履歴: 2026/05/14 新規作成 Tomoshige Momose
    ============================================== */

ls_proc_name constant varchar2(30) := 'proc_int_trantable';
ls_sql varchar2(4000);
ls_index_sql varchar2(4000);

ls_table_name varchar2(64);
ls_obj_cnt number;

cursor c_sql is
    select index_name from user_indexes
    where table_name = pi_table_name;

begin

select count(1) into ls_obj_cnt from user_tables
where table_name = pi_table_name;

-- 対象テーブルの存在チェック
if ls_obj_cnt = 0 then
    dbms_output.put_line(ls_proc_name || ': 対象テーブルが存在しません。');
    RAISE_APPLICATION_ERROR(-20001, 'not found target table.');
elsif pi_fiscal_id is null then
    dbms_output.put_line(ls_proc_name || ': 決算期コードが入力されていません。');
    RAISE_APPLICATION_ERROR(-20002, 'fiscal_id is null.');
end if;

-- 作成テーブル初期化
ls_table_name := pi_table_name || '_' || pi_fiscal_id;

select count(1) into ls_obj_cnt from user_tables
where table_name = ls_table_name;

if ls_obj_cnt > 0 then

    -- 存在する場合、Truncate
    ls_sql := 'TRUNCATE TABLE ' || ls_table_name ;
    execute immediate ls_sql;

else 
    -- 存在しない場合、新規作成
    ls_sql := 'CREATE TABLE ' || ls_table_name || ' AS SELECT * FROM ' || pi_table_name || ' WHERE 1=0';
    execute immediate ls_sql;

    for rec in c_sql loop

        begin

            ls_sql := 'SELECT DBMS_METADATA.GET_DDL(''INDEX'',''' || rec.index_name || ''') FROM DUAL';
            execute immediate ls_sql into ls_index_sql;

            ls_index_sql := replace(ls_index_sql, pi_table_name, ls_table_name);
            ls_index_sql := replace(ls_index_sql, rec.index_name, rec.index_name || '_' || pi_fiscal_id);
            execute immediate ls_index_sql;

        exception
            when others then
                dbms_output.put_line('Error occurred while creating index: ' || SQLERRM(SQLCODE) );
        end;

    end loop;

end if;

end;
/
