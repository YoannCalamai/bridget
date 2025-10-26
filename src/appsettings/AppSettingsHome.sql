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
    'System configuration' as title,
    '/appsettings/AppSettingsHome.sql' as link,
    TRUE   as active;

-- Menu list
SELECT 
    'list' as component, 
    'Menu' as title;
select
    'System info' as title,
    --'' as description,
    'info-circle' as icon,
    './SystemInfo.sql' as link,
    'blue' as color;
select
    'Application settings' as title,
    --'' as description,
    'settings' as icon,
    './AppSettings.sql' as link,
    'green' as color;
select
    'Notification configuration' as title,
    --'' as description,
    'notification' as icon,
    './NotificationConfig.sql' as link,
    'orange' as color;
