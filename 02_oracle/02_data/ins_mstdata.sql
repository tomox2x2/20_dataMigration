
/* ****************************************************** */
/* マスタデータ投入用                                       */
/* ****************************************************** */

truncate table m_actperiod;

-- 年次決算
insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2025', '0', '03', to_date('2024/04/01', 'YYYY/MM/DD'), to_date('2025/03/31', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '0', '03', to_date('2025/04/01', 'YYYY/MM/DD'), to_date('2026/03/31', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2027', '0', '03', to_date('2026/04/01', 'YYYY/MM/DD'), to_date('2027/03/31', 'YYYY/MM/DD'));

-- 月次決算
insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '1', '04', to_date('2026/04/01', 'YYYY/MM/DD'), to_date('2026/04/30', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '1', '05', to_date('2026/05/01', 'YYYY/MM/DD'), to_date('2026/05/31', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '1', '06', to_date('2026/06/01', 'YYYY/MM/DD'), to_date('2026/06/30', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '1', '07', to_date('2026/07/01', 'YYYY/MM/DD'), to_date('2026/07/31', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '1', '08', to_date('2026/08/01', 'YYYY/MM/DD'), to_date('2026/08/31', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '1', '09', to_date('2026/09/01', 'YYYY/MM/DD'), to_date('2026/09/30', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '1', '10', to_date('2026/10/01', 'YYYY/MM/DD'), to_date('2026/10/31', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '1', '11', to_date('2026/11/01', 'YYYY/MM/DD'), to_date('2026/11/30', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '1', '12', to_date('2026/12/01', 'YYYY/MM/DD'), to_date('2026/12/31', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2027', '1', '01', to_date('2027/01/01', 'YYYY/MM/DD'), to_date('2027/01/31', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2027', '1', '02', to_date('2027/02/01', 'YYYY/MM/DD'), to_date('2027/02/28', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2027', '1', '03', to_date('2027/03/01', 'YYYY/MM/DD'), to_date('2027/03/31', 'YYYY/MM/DD'));

-- 四半期決算)
insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '3', '06', to_date('2026/04/01', 'YYYY/MM/DD'), to_date('2026/06/30', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '3', '09', to_date('2026/07/01', 'YYYY/MM/DD'), to_date('2026/09/30', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '3', '12', to_date('2026/10/01', 'YYYY/MM/DD'), to_date('2026/12/31', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2027', '3', '01', to_date('2027/01/01', 'YYYY/MM/DD'), to_date('2027/03/31', 'YYYY/MM/DD'));

-- 半期決算
insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2026', '6', '09', to_date('2026/04/01', 'YYYY/MM/DD'), to_date('2026/09/30', 'YYYY/MM/DD'));

insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('2027', '6', '03', to_date('2026/10/01', 'YYYY/MM/DD'), to_date('2027/03/31', 'YYYY/MM/DD'));

-- テスト用(全件)
insert into m_actperiod  (fin_year, fin_class, fin_month, start_date, end_date) 
    values ('9999', 'A', '00', to_date('1901/01/01', 'YYYY/MM/DD'), to_date('2999/12/31', 'YYYY/MM/DD'));

commit;