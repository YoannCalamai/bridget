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
    'Users configuration' as title,
    '/user/UsersHome.sql' as link,
    TRUE   as active;

-- Menu list
SELECT 
    'list' as component, 
    'Menu' as title;
select
    'User list' as title,
    --'' as description,
    'users-group' as icon,
    './Users.sql' as link,
    'blue' as color;
select
    'Security profile' as title,
    --'' as description,
    'user-shield' as icon,
    './SecurityProfiles.sql' as link,
    'green' as color;
