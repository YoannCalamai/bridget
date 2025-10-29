-- Check session
select 'dynamic' as component, sqlpage.run_sql('./include/sessioncheck-user.sql') as properties;

-- charts
select 
    'chart'   as component,
    'Debit by Sub Categories' as title,
    'pie'     as type,
    TRUE      as labels;
SELECT
        sc.name as label,
        SUM(Value)*-1 as value
FROM BudTransaction as t
Join BudSubCategory as sc on sc.SubCategoryId=t.SubCategoryId
WHERE $AccountId IS NOT NULL
AND AccountId=$AccountId::int
AND Date between $startdate::date and $enddate::date
AND Value<0
AND (COALESCE(NULLIF($categoryid, ''), '-1')::int = -1 
     OR t.CategoryId = $categoryid::int)
AND (COALESCE(NULLIF($subcategoryid, ''), '-1')::int = -1 
     OR t.SubCategoryId = $subcategoryid::int)
GROUP BY sc.Name;
