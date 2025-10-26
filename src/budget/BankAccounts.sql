-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;

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
    '/budget/BankAccounts.sql' as link,
    TRUE   as active;

-- Page start
SELECT 'button' as component,
        'sm' as size;;
SELECT 'Add a bank account' as title,
        './BankAccount.sql' as link,
        'primary' as color,
        'square-rounded-plus' as icon;

SELECT 
    'table' as component,
    'IsActive' as icon,
    'action' as markdown,
    1 as sort,
    1 as search;
SELECT
    '[Edit](./BankAccount.sql?id=' || AccountId ||')' as Action,
    Name
FROM BudAccount
ORDER BY Name;

SELECT 'button' as component,
        'sm' as size;;
SELECT 'Add a bank account' as title,
        './BankAccount.sql' as link,
        'primary' as color,
        'square-rounded-plus' as icon;