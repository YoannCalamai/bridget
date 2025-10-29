-- Check session
select 'dynamic' as component, sqlpage.run_sql('./include/sessioncheck-user.sql') as properties;

-- charts
select 
    'chart'   as component,
    'Credit by Tags' as title,
    'pie'     as type,
    TRUE      as labels;
SELECT
        ta.name as label,
        SUM(Value) as value
FROM BudTransaction as tr
JOIN BudTransactionTag as tt on tr.TransactionId=tt.TransactionId
JOIN BudTag as ta on tt.TagId=ta.TagId
WHERE $AccountId IS NOT NULL
AND AccountId=$AccountId::int
AND Date between $startdate::date and $enddate::date
AND Value>0
GROUP BY ta.Name;
