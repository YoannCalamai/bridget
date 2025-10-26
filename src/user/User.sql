-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;

-- Page start
-- Alerts
select 'dynamic' as component, sqlpage.run_sql('include/alert-save-success-error.sql') as properties;

SELECT 
    'alert' as component,
    'Password successfully changed' as title,
    'confetti' as icon,
    'green' as color
WHERE $successpwd IS NOT NULL;

-- Navigation
select 
    'breadcrumb' as component;
select 
    'Home' as title,
    '/home.sql'    as link;
select 
    'Users List' as title,
    '/user/Users.sql' as link;
select 
    'User' as title,
    '/user/User.sql' as link,
    TRUE   as active;


-- Form
SELECT 
    'form' AS component,
    './userUpsert.sql' || COALESCE('?id=' || $id, '') as action,
    (SELECT CASE WHEN $id IS NOT NULL THEN 'Edit' ELSE 'Add' END || ' a user') AS title,
    (SELECT CASE WHEN $id IS NOT NULL THEN 'Edit' ELSE 'Add' END) AS validate;

-- firstname
SELECT 
    'Firstname' as name,
    'Firstname' as label,
    'text' as type,
    1 as required,
    1 as autofocus,
    (SELECT CASE WHEN $id IS NOT NULL THEN Firstname ELSE '' END 
    FROM CoreUser
    WHERE UserId = $id::int OR $id IS NULL LIMIT 1) as value;

-- lastname
SELECT 
    'Lastname' as name,
    'Lastname' as label,
    'text' as type,
    1 as required,
    1 as autofocus,
    (SELECT CASE WHEN $id IS NOT NULL THEN Lastname ELSE '' END 
    FROM CoreUser
    WHERE UserId = $id::int OR $id IS NULL LIMIT 1) as value;

-- email
SELECT 
    'Email' as name,
    'Email' as label,
    'email' as type,
    1 as required,
    (SELECT CASE WHEN $id IS NOT NULL THEN Email ELSE '' END 
    FROM CoreUser
    WHERE UserId = $id::int OR $id IS NULL LIMIT 1) as value;

-- security profile
SELECT 
    'SecurityProfileId' as name,
    'Security profile' as label,
    'select' as type,
    1 as required,
    (SELECT json_agg(json_build_object(
    'label', Name,
    'value', SecurityProfileId
    )) FROM CoreSecurityProfile) 
    as options,
    (SELECT CASE WHEN $id IS NOT NULL THEN SecurityProfileId ELSE -1 END 
    FROM CoreUser
    WHERE UserId = $id::int OR $id IS NULL LIMIT 1) as value;

-- language
SELECT 
    'LanguageId' as name,
    'Language' as label,
    'select' as type,
    1 as required,
    (SELECT json_agg(json_build_object(
    'label', Name,
    'value', LanguageId
    )) FROM SysLanguage
    WHERE IsEnable = true) as options,
    (SELECT CASE WHEN $id IS NOT NULL THEN LanguageId ELSE 1 END 
    FROM CoreUser
    WHERE UserId = $id::int OR $id IS NULL LIMIT 1) as value;

-- is active
SELECT 
    'IsActive' as name,
    'Is Active' as label,
    'checkbox' as type,
    (SELECT CASE WHEN $id IS NOT NULL THEN IsActive ELSE false END 
    FROM CoreUser
    WHERE UserId = $id::int OR $id IS NULL LIMIT 1) as checked;

SELECT
    'divider' as component,
    'Password' as contents,
    'left' as position,
    'blue' as color,
    TRUE as bold
WHERE $id IS NOT NULL;

SELECT 
    'form' AS component,
    './userChangepassword.sql' || COALESCE('?id=' || $id, '') as action,
    'Change the user''s password' AS title,
    'Apply the new password' AS validate
WHERE $id IS NOT NULL;

SELECT 
    'Password' AS name, 
    'Password' as label,
    'password' AS type,
    1 as required,
    '^.*(?=.{12,})(?=.*[a-zA-Z])(?=.*\d)(?=.*[!#$%&? "]).*$' AS pattern, 
    'Your password should contain at least 12 characters and at least a letter, a number and a special char(!#$%&? ").' AS description
WHERE $id IS NOT NULL;