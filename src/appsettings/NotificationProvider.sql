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
    'System configuration' as title,
    '/appsettings/AppSettingsHome.sql' as link;
select 
    'Notification configuration' as title,
    '/appsettings/NotificationConfig.sql' as link;
select 
    'Notification provider' as title,
    '/appsettings/NotificationProvider.sql' as link,
    TRUE   as active;

-- Form
SELECT 'form' AS component,
        './notificationproviderUpsert.sql'|| COALESCE('?id=' || $id, '') as action,
        'Notification provider' AS title,
        'Save' AS validate;

-- NotificationType
select 'NotificationType'  as name,
       'Notification type' as label,
       'select' as type,
       1 as required,
       '[{"label": "Disabled", "value": -1},{"label": "PDF Generation", "value": 0}]' as options,
       (SELECT NotificationType FROM NotificationProvider
        WHERE NotificationProviderId=$id::int) as value;

-- Name
select 'Name'  as name,
       'Name' as label,
       'text' as type,
       1 as required,
       255 as maxlength,
       (SELECT Name FROM NotificationProvider
        WHERE NotificationProviderId=$id::int) as value;
