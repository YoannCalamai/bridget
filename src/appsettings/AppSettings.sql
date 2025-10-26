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
    'Application Settings' as title,
    '/appsettings/AppSettings.sql' as link,
    TRUE   as active;

-- Form
SELECT 'form' AS component,
        './appsettingsUpdate.sql' as action,
        'Application Settings' AS title,
        'Save' AS validate;

SELECT 'AssociationShortname' as name,
        'Company shortname' as label,
        'text' as type,
        1 as required,
        1024 as maxlength,
        Value
FROM AppSettings
WHERE AppSettingid=1;

SELECT 'AssociationLongname' as name,
        'Company name' as label,
        'text' as type,
        1 as required,
        1024 as maxlength,
        Value
FROM AppSettings
WHERE AppSettingid=2;

SELECT 'IndexTitle' as name,
        'Index page title' as label,
        'text' as type,
        1 as required,
        1024 as maxlength,
        Value
FROM AppSettings
WHERE AppSettingid=3;

SELECT 'IndexDescription' as name,
        'Index page description' as label,
        'textarea' as type,
        1 as required,
        1024 as maxlength,
        Value
FROM AppSettings
WHERE AppSettingid=4;

SELECT 'IndexImage' as name,
        'index page image url' as label,
        'url' as type,
        1 as required,
        1024 as maxlength,
        Value
FROM AppSettings
WHERE AppSettingid=5;

SELECT 'IsPasswordRecoveryActive' as name,
        'Activate password recovery' as label,
        'checkbox' as type,
        CASE Value WHEN '1' THEN true else false END as checked
FROM AppSettings
WHERE AppSettingid=6;