-- Check session
select 'dynamic' as component, sqlpage.run_sql('./include/sessioncheck-user.sql') as properties;

-- charts
select 
    'chart'   as component,
    'Debit by Categories' as title,
    'pie'     as type,
    TRUE      as labels;
SELECT
        c.name as label,
        SUM(Value)*-1 as value
FROM BudTransaction as t
Join BudCategory as c on c.CategoryId=t.CategoryId
WHERE $AccountId IS NOT NULL
AND AccountId=$AccountId::int
AND Date between $startdate::date and $enddate::date
AND Value<0
AND (COALESCE(NULLIF($categoryid, ''), '-1')::int = -1 
     OR c.CategoryId = $categoryid::int)
GROUP BY c.Name;
