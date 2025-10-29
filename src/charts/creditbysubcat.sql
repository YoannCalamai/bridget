-- Check session
select 'dynamic' as component, sqlpage.run_sql('./include/sessioncheck-user.sql') as properties;

-- charts
select 
    'chart'   as component,
    'Credit by Sub Categories' as title,
    'pie'     as type,
    TRUE      as labels;
SELECT
        c.name as label,
        SUM(Value) as value
FROM BudTransaction as t
Join BudSubCategory as c on c.SubCategoryId=t.SubCategoryId
WHERE $AccountId IS NOT NULL
AND AccountId=$AccountId::int
AND Date between $startdate::date and $enddate::date
AND Value>0
GROUP BY c.Name;
