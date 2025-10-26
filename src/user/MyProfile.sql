-- Check session
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

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
    'My profile' as title,
    '/employee/MyProfile.sql' as link,
    TRUE   as active;

-- Form
SELECT 'form' AS component,
        './myprofileUpdate.sql' || COALESCE('?id=' || $id, '') as action,
        'Modify my profile' AS title,
        'Modify' AS validate;

SELECT 'Firstname' as name,
        'First name' as label,
        'text' as type,
        1 as required,
        1 as autofocus,
        Firstname as value
FROM GetUserFromSession WHERE Session = sqlpage.cookie('session');

SELECT 'Lastname' as name,
        'Last name' as label,
        'text' as type,
        1 as required,
        0 as autofocus,
        Lastname as value
FROM GetUserFromSession WHERE Session = sqlpage.cookie('session');

SELECT 'Email' as name,
        'Email' as label,
        'email' as type,
        1 as required,
        Email as value
FROM GetUserFromSession WHERE Session = sqlpage.cookie('session');

-- language
SELECT 'LanguageId' as name,
        'Language' as label,
        'select' as type,
        1 as required,
        (SELECT json_agg(json_build_object(
        'label', Name,
        'value', LanguageId
        )) FROM SysLanguage
        WHERE IsEnable = true) as options,
        coalesce(LanguageId,1) as value
FROM GetUserFromSession WHERE Session = sqlpage.cookie('session');


-- dark mode disenable
SELECT 
    'button' as component,
    'pill'   as shape;

SELECT 
    'Dark mode enable/disable' as title,
    'darkmodeDisenable.sql' as link,
    'brightness-up' as icon,
    CASE COALESCE(sqlpage.cookie('lightdarkstatus'),'')
    WHEN '' THEN 'dark'
    ELSE 'light' END as outline;