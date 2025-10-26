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
    'Budget Home' as title,
    '/budget/BudgetHome.sql' as link;
select 
    'Categories and Tags Lists' as title,
    '/budget/CategoriesTags.sql' as link;
select 
    'Category' as title,
    '/budget/Category.sql' as link;


-- Form
SELECT 
    'form' AS component,
    './categoryautoconfUpsert.sql?cid=' || $cid || COALESCE('&id=' || $id, '') as action,
    (SELECT CASE WHEN $id IS NOT NULL THEN 'Edit' ELSE 'Add' END || ' a transaction name to match') AS title,
    (SELECT CASE WHEN $id IS NOT NULL THEN 'Edit' ELSE 'Add' END) AS validate;

-- Name
SELECT 
    'TransactionName' as name,
    'text' as type,
    1 as required,
    1 as autofocus,
    (SELECT CASE WHEN $id IS NOT NULL THEN TransactionName ELSE '' END 
    FROM BudCategoryAutoConfiguration
    WHERE CategoryAutoConfigurationId = $id::int OR $id IS NULL LIMIT 1) as value;

-- Description
SELECT 
    'TransactionDescription' as name,
    'text' as type,
    (SELECT CASE WHEN $id IS NOT NULL THEN TransactionDescription ELSE '' END 
    FROM BudCategoryAutoConfiguration
    WHERE CategoryAutoConfigurationId = $id::int OR $id IS NULL LIMIT 1) as value;

