SELECT
date1.YEAR ,
ma.ACCOUNT_TYPE , ma.ACCOUNT_CODE, ma.ACCOUNT_NAME ,
sum( COALESCE(tj2.DEBIT_AMOUNT, 0) + coalesce( tj2.CREDIT_AMOUNT,0) * -1 ) AS AMOUNT
FROM act1.T_JOURNAL_HEADER tj1
INNER JOIN (
SELECT
'2025' AS YEAR,
cast ('2025-04-01' as date) AS FROMDATE,
cast ('2025-04-01' as date) + interval '12' month - interval '1' day as TODATE
union
SELECT
'2026' AS YEAR,
cast ('2026-04-01' as date) AS FROMDATE,
cast ('2026-04-01' as date) + interval '12' month - interval '1' day as TODATE
) date1 ON tj1.JOURNAL_DATE BETWEEN date1.FROMDATE AND date1.TODATE
INNER JOIN act1.T_JOURNAL_DETAIL tj2 ON tj1.JOURNAL_ID = tj2.JOURNAL_ID
INNER JOIN act1.M_ACCOUNT ma ON tj2.account_ID = ma.ACCOUNT_ID
GROUP BY
date1.YEAR ,
ma.ACCOUNT_TYPE , ma.ACCOUNT_CODE, ma.ACCOUNT_NAME
ORDER BY date1.year, ma.ACCOUNT_CODE
