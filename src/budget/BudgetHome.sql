-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;

-- Navigation
select 
    'breadcrumb' as component;
select 
    'Home' as title,
    '/home.sql'    as link;
select 
    'Budget' as title,
    '/badget/BudgetHome.sql' as link,
    TRUE   as active;

-- Menu list
SELECT 
    'list' as component, 
    'Menu' as title;
select
    'Import transactions' as title,
    --'' as description,
    'database-plus' as icon,
    './Import.sql' as link,
    'blue' as color;
select
    'Bank Accounts' as title,
    --'' as description,
    'pig' as icon,
    './BankAccounts.sql' as link,
    'pink' as color;
select
    'Categories & Tags' as title,
    --'' as description,
    'tag' as icon,
    './CategoriesTags.sql' as link,
    'green' as color;

