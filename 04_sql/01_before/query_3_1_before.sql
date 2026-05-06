SELECT w1.JOURNAL_DATE , sum(CNT) AS CNT
FROM (
SELECT
tj1.JOURNAL_ID,
tj1.journal_date,
(SELECT COUNT(*)
FROM act1.t_journal_detail tj2
WHERE tj2.journal_id = tj1.journal_id) AS CNT
FROM act1.t_journal_header tj1
) w1
GROUP BY w1.JOURNAL_DATE
ORDER by w1.JOURNAL_DATE ;
