-- Check session
select 'dynamic' as component, sqlpage.run_sql('./include/sessioncheck-user.sql') as properties;

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;

-- Page start
SELECT 'text' AS component,
        (select 'Hi, ' || Firstname || ' !' from GetUserFromSession where Session = sqlpage.cookie('session')) AS title;

-- Display report parameters form
SELECT 'form' AS component,
    'Display parameters' AS title,
    'Show' as validate;
SELECT 'AccountId' AS name,
    'select' AS type,
    'Bank account' AS label,
    (
        SELECT json_agg(
                json_build_object('label', Name, 'value', AccountId)
            )
        FROM BudAccount
    ) as options,
    TRUE AS required;
SELECT 'startdate' AS name,
    'date' AS type,
    'From' AS label,
    CASE WHEN :startdate IS NULL THEN TO_CHAR(DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month'),'YYYY-MM-DD')
    ELSE :startdate END as value,
    TRUE AS required;
SELECT 'enddate' AS name,
    'date' AS type,
    'To' AS label,
    CASE WHEN :enddate IS NULL THEN TO_CHAR(DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 day','YYYY-MM-DD') 
    ELSE :enddate END as value,
    TRUE AS required;
SELECT 'CategoryId' AS name,
    'select' AS type,
    'Category' AS label,
    true as searchable,
    '-- No selection' as empty_option,
    (
        SELECT json_agg(
                json_build_object('label', Name, 'value', CategoryId)
            )
        FROM BudCategory
    ) as options,
    CASE WHEN :CategoryId IS NULL THEN '' 
    ELSE :CategoryId END as value;

-- Display statistics
SELECT 'datagrid' AS component;
SELECT 'Transactions' AS title,
    COUNT(*)::TEXT AS description,
    'database' AS icon,
    'yellow' AS color
FROM BudTransaction
WHERE :AccountId IS NOT NULL
AND AccountId=:AccountId::int
AND Date between :startdate::date and :enddate::date
AND (COALESCE(NULLIF(:CategoryId, ''), '-1')::int = -1 
     OR CategoryId = :CategoryId::int);
SELECT 'Total Debit' AS title,
    TO_CHAR(SUM(COALESCE(Value, 0)), 'FM999,999,999.00') || ' €' AS description,
    'red' AS color
FROM BudTransaction
WHERE :AccountId IS NOT NULL
AND AccountId=:AccountId::int
AND Date between :startdate::date and :enddate::date
AND (COALESCE(NULLIF(:CategoryId, ''), '-1')::int = -1 
     OR CategoryId = :CategoryId::int)
AND Value < 0;
SELECT 'Total Credit' AS title,
    TO_CHAR(SUM(COALESCE(Value, 0)), 'FM999,999,999.00') || ' €' AS description,
    'green' AS color
FROM BudTransaction
WHERE :AccountId IS NOT NULL
AND AccountId=:AccountId::int
AND Date between :startdate::date and :enddate::date
AND (COALESCE(NULLIF(:CategoryId, ''), '-1')::int = -1 
     OR CategoryId = :CategoryId::int)
AND Value>0;
SELECT 'Balance' AS title,
    TO_CHAR(
        SUM(COALESCE(Value, 0)),
        'FM999,999,999.00'
    ) || ' €' AS description,
    'scale' AS icon,
    'blue' AS color
FROM BudTransaction
WHERE :AccountId IS NOT NULL
AND AccountId=:AccountId::int
AND (COALESCE(NULLIF(:CategoryId, ''), '-1')::int = -1 
     OR CategoryId = :CategoryId::int)
AND Date between :startdate::date and :enddate::date;

-- charts
select 
    'card' as component,
    2 as columns;
select 
    '/charts/debitbycat.sql?AccountId='|| :AccountId ||
                          '&startdate='|| :startdate ||
                          '&enddate='|| :enddate ||
                          CASE WHEN COALESCE(NULLIF(:CategoryId, ''), '-1')::int =-1 THEN ''
                          ELSE '&categoryid=' ||:CategoryId::int END ||
                          '&_sqlpage_embed' as embed;
select 
    '/charts/debitbytag.sql?AccountId='|| :AccountId ||
                          '&startdate='|| :startdate ||
                          '&enddate='|| :enddate ||
                          CASE WHEN COALESCE(NULLIF(:CategoryId, ''), '-1')::int =-1 THEN ''
                          ELSE '&categoryid=' ||:CategoryId::int END ||
                          '&_sqlpage_embed' as embed;

-- Show transactions
SELECT 'table' AS component,
    'List of Transactions' AS title,
    'action' as markdown,
    TRUE AS sort,
    TRUE AS search,
    TRUE AS striped_rows
    WHERE :AccountId IS NOT NULL;
SELECT 
    '[Edit](/budget/Transaction.sql?id=' || TransactionId ||')' as Action,
    TO_CHAR(Date, 'DD/MM/YYYY') AS "Date",
    t.Name AS "Name",
    t.Description AS "Description",
    Type AS "Type",
    c.Name AS "Category",
    --sous_categorie AS "Sub-Category",
    CASE
        WHEN COALESCE(Value, 0) < 0 THEN TO_CHAR(Value, 'FM999,999,999.00') || ' €'
        ELSE ''
    END AS "Debit",
    CASE
        WHEN COALESCE(Value, 0) > 0 THEN '+' || TO_CHAR(Value, 'FM999,999,999.00') || ' €'
        ELSE ''
    END AS "Credit"
FROM BudTransaction as t
Join BudCategory as c on c.CategoryId=t.CategoryId
WHERE :AccountId IS NOT NULL
AND AccountId=:AccountId::int
AND Date between :startdate::date and :enddate::date
AND (COALESCE(NULLIF(:CategoryId, ''), '-1')::int = -1 
     OR t.CategoryId = :CategoryId::int)
ORDER BY Date DESC, Transactionid DESC;