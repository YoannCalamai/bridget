-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;

-- Page start
-- Alerts
select 'dynamic' as component, sqlpage.run_sql('include/alert-save-success-error.sql') as properties;

-- Navigation
-- Navigation
select 
    'breadcrumb' as component;
select 
    'Home' as title,
    '/home.sql'    as link;
select 
    'Budget Home' as title,
    '/budget/BudgetHome.sql' as link;
select 
    'Bank Accounts List' as title,
    '/budget/BankAccounts.sql' as link;
select 
    'Bank Account' as title,
    '/budget/BankAccount.sql' as link,
    TRUE   as active;


-- Form
SELECT 
    'form' AS component,
    './bankaccountUpsert.sql' || COALESCE('?id=' || $id, '') as action,
    (SELECT CASE WHEN $id IS NOT NULL THEN 'Edit' ELSE 'Add' END || ' a bank account') AS title,
    (SELECT CASE WHEN $id IS NOT NULL THEN 'Edit' ELSE 'Add' END) AS validate;

-- Name
SELECT 
    'Name' as name,
    'text' as type,
    1 as required,
    1 as autofocus,
    (SELECT CASE WHEN $id IS NOT NULL THEN Name ELSE '' END 
    FROM BudAccount
    WHERE AccountId = $id::int OR $id IS NULL LIMIT 1) as value;

