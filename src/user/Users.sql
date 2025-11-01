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
    'Users List' as title,
    '/user/Users.sql' as link,
    TRUE   as active;

-- Page start

SELECT 
    'datagrid' as component,
    'Users list' as title;
SELECT 
    'Number of users' as title,
    count(UserId) as description
FROM CoreUser
WHERE UserId>0;
SELECT 
    'Number of active users' as title,
    count(UserId) as description
FROM CoreUser
WHERE IsActive=true
AND UserId>0;

select 
    'divider' as component,
    'Actions'   as contents;
SELECT 'button' as component,
        'sm' as size;;
SELECT 'Add a user' as title,
        './User.sql' as link,
        'primary' as color,
        'mood-plus' as icon;

SELECT 
    'table' as component,
    'IsActive' as icon,
    '/user/User.sql?id={id}' as edit_url,
    1 as sort,
    1 as search;
SELECT
    UserId as _sqlpage_id,
    Firstname || ' ' || Lastname as User,
    Email,
    CASE IsActive WHEN true THEN 'check' ELSE '' END as IsActive,
    CASE IsActive WHEN true THEN '' ELSE 'text-muted' END as _sqlpage_css_class
FROM CoreUser
WHERE UserId>0
ORDER BY IsActive, Firstname;

SELECT 'button' as component,
        'sm' as size;;
SELECT 'Add a user' as title,
        './User.sql' as link,
        'primary' as color,
        'mood-plus' as icon;