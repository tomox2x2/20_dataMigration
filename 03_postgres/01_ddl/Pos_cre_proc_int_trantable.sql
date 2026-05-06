CREATE OR REPLACE PROCEDURE act1.proc_int_trantable(
    IN pi_fiscal_id VARCHAR, 
    IN pi_table_name VARCHAR ,
    IN pi_schema_name VARCHAR DEFAULT 'act1'
)
AS 
$BODY$

 /* ==============================================
    proc_int_trantable
    Process Overview:
          Initialize and create transaction tables
    input : pi_fiscal_id   -- fiscal year ID
            pi_table_name  -- base table name for creating transaction table
            pi_schema_name -- schema name (default: act1)
    output: none
    update record: 2026/05/14 create Tomoshige Momose
    ============================================== 
*/

DECLARE
    cs_proc_name CONSTANT VARCHAR(30) := 'proc_int_trantable';

    ls_sql TEXT;

    ls_schema_name_lower VARCHAR(80);
    ls_table_base_lower VARCHAR(80);

    ls_source_table_name VARCHAR(80);
    ls_table_name VARCHAR(80);
    ls_obj_cnt INTEGER;

    rec RECORD;

BEGIN

    ls_schema_name_lower := LOWER(pi_schema_name);
    ls_table_base_lower := LOWER(pi_table_name);

    SELECT
        COUNT(1)
        INTO ls_obj_cnt
        FROM pg_tables
        WHERE schemaname = ls_schema_name_lower 
        AND   tablename = ls_table_base_lower;

    /* source table exists check */
    IF ls_obj_cnt = 0 THEN
        RAISE NOTICE '%: not exists source table.', cs_proc_name;
        RAISE 'not found source table.' USING ERRCODE = 'P0001';
    ELSIF pi_fiscal_id IS NULL THEN
        RAISE NOTICE '%: not found fiscal_id.', cs_proc_name;
        RAISE 'fiscal_id is null.' USING ERRCODE = 'P0002';
    END IF;

    /* target table initialization */
    ls_source_table_name := ls_table_base_lower;
    ls_table_name := ls_source_table_name || '_' || pi_fiscal_id;

    SELECT
        COUNT(1)
        INTO ls_obj_cnt
        FROM pg_tables
        WHERE schemaname = ls_schema_name_lower 
        AND   tablename = ls_table_name;

    IF ls_obj_cnt > 0 THEN
        /* target table exists : truncate it */
        ls_sql := format('TRUNCATE TABLE %I.%I', ls_schema_name_lower, ls_table_name);

        RAISE NOTICE 'truncate table: %', ls_sql;
        EXECUTE ls_sql;
    ELSE
        /* target table not exists : create it */
        ls_sql := format('CREATE TABLE %I.%I AS SELECT * FROM %I.%I WHERE 1=0', 
                          ls_schema_name_lower,
                          ls_table_name, 
                          ls_schema_name_lower,
                          ls_source_table_name);
        RAISE NOTICE 'create table: %', ls_sql;
        EXECUTE ls_sql;

        /* create index */
        ls_sql := format(
            $fmt$
            SELECT replace(
                    replace(
                    indexdef,
                    %L,
                    %L
                    ), 
                indexname,
                indexname || '_' || %L)
                as indexdef
            FROM pg_indexes 
            WHERE schemaname = %L 
            AND tablename = %L
            $fmt$,
            ls_source_table_name,
            ls_table_name,
            pi_fiscal_id,
            ls_schema_name_lower,
            ls_source_table_name
        );

        RAISE NOTICE 'index create read: %', ls_sql;

        FOR rec IN EXECUTE ls_sql LOOP

            BEGIN
                RAISE NOTICE 'Creating index: %', rec.indexdef;
                EXECUTE rec.indexdef;
            EXCEPTION
                WHEN OTHERS THEN
                    RAISE NOTICE 'Error occurred while creating index: %', SQLERRM;
                    RAISE;
            END;
            
        END LOOP;

    END IF;
END;
$BODY$
LANGUAGE plpgsql;
