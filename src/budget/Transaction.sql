-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        '/home.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT TransactionId FROM BudTransaction);

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;

-- Page start
-- Alerts
select 'dynamic' as component, sqlpage.run_sql('include/alert-save-success-error.sql') as properties;

-- Navigation
select 
    'breadcrumb' as component;
select 
    'Home' as title,
    '/home.sql'    as link;

SELECT 'datagrid' AS component;
SELECT 'Date' AS title,
    Date AS description
FROM BudTransaction
WHERE TransactionId = $id::int;
SELECT 'Name' AS title,
    Name AS description
FROM BudTransaction
WHERE TransactionId = $id::int;
SELECT 'Description' AS title,
    description AS description
FROM BudTransaction
WHERE TransactionId = $id::int;
SELECT 'Type' AS title,
    Type AS description
FROM BudTransaction
WHERE TransactionId = $id::int;
SELECT 'Value' AS title,
    Value AS description,
    CASE 
        WHEN Value > 0 THEN 'green'
        WHEN Value < 0 THEN 'red'
    ELSE '' END
    AS color
FROM BudTransaction
WHERE TransactionId = $id::int;



-- Form
SELECT 
    'form' AS component,
    './transactionUpdate.sql' || COALESCE('?id=' || $id, '') as action,
    'Change Category' AS title,
    'Edit' AS validate;

-- category
SELECT 
    'CategoryId' as name,
    'Category' as label,
    'select' AS type,
    true as required,
    (
        SELECT json_agg(
                json_build_object('label', Name, 'value', CategoryId)
                ORDER BY Name
            )
        FROM BudCategory
    ) as options,
    (SELECT CASE WHEN $id IS NOT NULL THEN CategoryId ELSE -1 END 
    FROM BudTransaction
    WHERE TransactionId = $id::int) as value;

-- subcategory
SELECT 
    'SubcategoryId' as name,
    'Sub Category' as label,
    'select' AS type,
    true as required,
    (
        SELECT json_agg(
                json_build_object('label', Name, 'value', SubCategoryId)
                ORDER BY Name
            )
        FROM BudSubCategory
    ) as options,
    (SELECT CASE WHEN $id IS NOT NULL THEN SubCategoryId ELSE -1 END 
    FROM BudTransaction
    WHERE TransactionId = $id::int) as value;

SELECT 'divider' as component,
       'Tags' as contents;

SELECT 'button' as component,
        'sm' as size;
SELECT 'Assign a tag' as title,
        './TransactionTag.sql?cid=' || $id as link,
        'primary' as color,
        'square-rounded-plus' as icon
WHERE $id is not null;

SELECT 
    'table' as component,
    'IsActive' as icon,
    '/budget/TransactionTag.sql?cid=' || $id || '&id={id}' as edit_url,
    '/budget/transactiontagDelete.sql?cid=' || $id || '&id={id}' as delete_url,
    1 as sort,
    1 as search;
SELECT
    TransactionTagId as _sqlpage_id,
    Name
FROM BudTransactionTag as tt
JOIN BudTag as ta on tt.TagId = ta.TagId
WHERE TransactionId=$id::int
ORDER BY Name;

SELECT 'button' as component,
        'sm' as size;
SELECT 'Assign a tag' as title,
        './TransactionTag.sql?cid=' || $id as link,
        'primary' as color,
        'square-rounded-plus' as icon
WHERE $id is not null;
