-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

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
select 
    'Transaction' as title,
    '/budget/Transaction.sql?id=' || $cid as link;
select 
    'Tag' as title,
    '/budget/TransactionTag.sql' as link,
    true as active;


-- Form
SELECT 
    'form' AS component,
    './transactiontagUpsert.sql?cid=' || $cid || COALESCE('&id=' || $id, '') as action,
    'Affect a tag' AS title,
    'Add' AS validate;

-- Tag
SELECT 
    'TagId' as name,
    'Tag' as label,
    'select' AS type,
    true as required,
    (
        SELECT json_agg(
                json_build_object('label', Name, 'value', TagId)
                ORDER BY Name
            )
        FROM BudTag
    ) as options,
    (SELECT CASE WHEN $id IS NOT NULL THEN TagId ELSE -1 END 
    FROM BudTransactionTag
    WHERE TransactionId = $id::int) as value;
