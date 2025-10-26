-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-public.sql') as properties;

SELECT 'alert' as component,
    'Oups' as title,
    'We cannot authenticate you' as description_md,
    'alert-circle' as icon,
    'red' as color
WHERE $error IS NOT NULL;

SELECT 'alert' as component,
    'Password successfully changed' as title,
    'circle-check' as icon,
    'green' as color
WHERE $successpwd IS NOT NULL;

SELECT 'form' AS component,
       'Authentication' AS title,
       'Log in' AS validate,
       'loginaction.sql' AS action;

SELECT 'username' AS name,
       'Email' as label,
       'true' as autofocus,
       'true' as required;
SELECT 'password' AS name,
       'Password' as label,
       'true' as required,
       'password' AS type;

select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape
FROM AppSettings
WHERE AppSettingId=7
AND Value='1';
select 
    'Forgot your password?' as title,
    'red' as outline,
    'ForgotPassword.sql' as link,
    'lock-question' as icon
FROM AppSettings
WHERE AppSettingId=7
AND Value='1';