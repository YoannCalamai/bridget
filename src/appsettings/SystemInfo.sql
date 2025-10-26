-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;

-- Page start

-- Navigation
select 
    'breadcrumb' as component;
select 
    'Home' as title,
    '/home.sql'    as link;
select 
    'System configuration' as title,
    '/appsettings/AppSettingsHome.sql' as link;
select 
    'System info' as title,
    '/appsettings/SystemInfo.sql' as link,
    TRUE   as active;


select 
    'datagrid' as component,
    'System Information' as title;
select 
    'Application version'  as title,
    'vVERSIONNUMBERPLACEHOLDER' as description;
select 
    'SQLPage version'  as title,
    sqlpage.version() as description;
select
    'Working dir' as title,
    sqlpage.current_working_directory() as description;
-- display connection string only for super administrator
select
    'Connection string' as title,
    sqlpage.environment_variable('DATABASE_URL') as description
FROM GetUserFromSession WHERE Session = sqlpage.cookie('session') 
AND UserId=0;