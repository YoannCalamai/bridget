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
    'Categories and Tags Lists' as title,
    '/budget/CategoriesTags.sql' as link,
    TRUE   as active;

-- Page start

----- CATEGORIES
SELECT 'divider' as component,
       'Categories' as contents;

SELECT 'button' as component,
        'sm' as size;
SELECT 'Add a category' as title,
        './Category.sql' as link,
        'primary' as color,
        'square-rounded-plus' as icon;

SELECT 
    'table' as component,
    'IsActive' as icon,
    'action' as markdown,
    1 as sort,
    1 as search;
SELECT
    '[Edit](./Category.sql?id=' || CategoryId ||')' as Action,
    Name
FROM BudCategory
ORDER BY Name;

SELECT 'button' as component,
        'sm' as size;
SELECT 'Add a category' as title,
        './Category.sql' as link,
        'primary' as color,
        'square-rounded-plus' as icon;


----- SUBCATEGORIES
SELECT 'divider' as component,
       'Subcategories' as contents;

SELECT 'button' as component,
        'sm' as size;
SELECT 'Add a subcategory' as title,
        './Subcategory.sql' as link,
        'primary' as color,
        'square-rounded-plus' as icon;

SELECT 
    'table' as component,
    'IsActive' as icon,
    'action' as markdown,
    1 as sort,
    1 as search;
SELECT
    '[Edit](./Subcategory.sql?id=' || SubCategoryId ||')' as Action,
    Name
FROM BudSubCategory
ORDER BY Name;

SELECT 'button' as component,
        'sm' as size;
SELECT 'Add a subcategory' as title,
        './Subcategory.sql' as link,
        'primary' as color,
        'square-rounded-plus' as icon;

----- TAGS
SELECT 'divider' as component,
       'Tags' as contents;

SELECT 'button' as component,
        'sm' as size;;
SELECT 'Add a tag' as title,
        './Tag.sql' as link,
        'primary' as color,
        'square-rounded-plus' as icon;

SELECT 
    'table' as component,
    'IsActive' as icon,
    'action' as markdown,
    1 as sort,
    1 as search;
SELECT
    '[Edit](./Tag.sql?id=' || TagId ||')' as Action,
    Name
FROM BudTag
ORDER BY Name;

SELECT 'button' as component,
        'sm' as size;
SELECT 'Add a tag' as title,
        './Tag.sql' as link,
        'primary' as color,
        'square-rounded-plus' as icon;