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
    'Subcategory' as title,
    '/budget/Subcategory.sql' as link,
    TRUE   as active;


-- Form
SELECT 
    'form' AS component,
    './subcategoryUpsert.sql' || COALESCE('?id=' || $id, '') as action,
    (SELECT CASE WHEN $id IS NOT NULL THEN 'Edit' ELSE 'Add' END || ' a subcategory') AS title,
    (SELECT CASE WHEN $id IS NOT NULL THEN 'Edit' ELSE 'Add' END) AS validate;

-- Name
SELECT 
    'Name' as name,
    'text' as type,
    1 as required,
    1 as autofocus,
    (SELECT CASE WHEN $id IS NOT NULL THEN Name ELSE '' END 
    FROM BudSubCategory
    WHERE SubcategoryId = $id::int OR $id IS NULL LIMIT 1) as value;

SELECT 'divider' as component,
       'Auto Configuration' as contents;

SELECT 'button' as component,
        'sm' as size;
SELECT 'Add an auto configuration' as title,
        './SubcategorieAutoConfig.sql?cid=' || $id as link,
        'primary' as color,
        'square-rounded-plus' as icon
WHERE $id is not null;

SELECT 
    'table' as component,
    'IsActive' as icon,
    '/budget/SubcategorieAutoConfig.sql?cid=' || $id || '&id={id}' as edit_url,
    1 as sort,
    1 as search;
SELECT
    SubCategoryAutoConfigurationId as _sqlpage_id,
    TransactionName
FROM BudSubCategoryAutoConfiguration
WHERE SubCategoryId=$id::int
ORDER BY TransactionName;

SELECT 'button' as component,
        'sm' as size;;
SELECT 'Add an auto configuration' as title,
        './SubcategorieAutoConfig.sql?cid=' || $id as link,
        'primary' as color,
        'square-rounded-plus' as icon
WHERE $id is not null;
