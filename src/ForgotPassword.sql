SELECT 'redirect' AS component,
        '/' AS link
FROM AppSettings
WHERE AppSettingId=6
AND Value='0';

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-public.sql') as properties;

SELECT 'alert' as component,
    'An email has been sent to your address' as title,
    'circle-check' as icon,
    'green' as color
WHERE $success IS NOT NULL;

SELECT 'form' AS component,
       'Forgot your password?' AS title,
       'Reinit my password' AS validate,
       'forgotpasswordaction.sql' AS action;

SELECT 'email' AS name,
       'Email' as label,
       'true' as autofocus,
       'true' as required;