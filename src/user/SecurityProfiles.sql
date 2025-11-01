-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;

-- Alerts
select 'dynamic' as component, sqlpage.run_sql('include/alert-save-success-error.sql') as properties;

-- Navigation
select 
    'breadcrumb' as component;
select 
    'Home' as title,
    '/home.sql'    as link;
select 
    'Users configuration' as title,
    '/user/UsersHome.sql' as link;
select 
    'Security Profile List' as title,
    '/user/SecurityProfiles.sql' as link,
    TRUE as active;

-- Actions
SELECT 
    'button' as component,
    --'' as shape,
    'sm' as size;
SELECT 'Add a new Security Profile' as title,
    './SecurityProfile.sql' AS link,
    'primary' as color,
    'plus' as icon;


-- List
SELECT 
    'table' as component,
    '/user/SecurityProfile.sql?id={id}' as edit_url,
    1 as striped_rows,
    1 as sort,
    1 as search;
SELECT
    SecurityProfileId as _sqlpage_id,
    Name
FROM CoreSecurityProfile
WHERE SecurityProfileId > 0;

-- Actions
SELECT 
    'button' as component,
    --'' as shape,
    'sm' as size;
SELECT 'Add a new Security Profile' as title,
    './SecurityProfile.sql' AS link,
    'primary' as color,
    'plus' as icon;
