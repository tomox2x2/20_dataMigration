SELECT
tj1.journal_date,
sum(
 (SELECT COUNT(*)
  FROM act1.t_journal_detail tj2
  WHERE tj2.journal_id = tj1.journal_id)) AS CNT
FROM act1.t_journal_header tj1
GROUP BY tj1.JOURNAL_DATE
ORDER by tj1.JOURNAL_DATE ;
