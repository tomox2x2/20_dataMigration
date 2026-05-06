
/* ****************************************************** */
/* システムパラメータ設定用データ投入用                      */
/* ****************************************************** */

truncate table d_sysparam;

insert into d_sysparam 
    (param_id, param_name, param_value, description) 
    values
     (1001, 'CLOSE_MONTH', '3', '決算月');

commit;