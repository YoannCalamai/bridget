-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Redirect to Home page if id query parameter is invalid
SELECT 'dynamic' as component, sqlpage.run_sql('include/inputcheck.sql',
                                               json_object('id', COALESCE($id,1337))) as properties
WHERE $id IS NOT NULL;

SELECT 
    'redirect' AS component,
    '/home.sql' AS link
WHERE $id::int NOT IN (SELECT SecurityProfileId FROM CoreSecurityProfile);

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
    '/user/SecurityProfiles.sql' as link;
select 
    'Security Profile' as title,
    '/user/SecurityProfile.sql' as link,
    TRUE as active;


-- Security Profile Form
SELECT 
    'form' AS component,
    './securityprofileUpsert.sql' || COALESCE('?id=' || $id, '') as action,
    (SELECT CASE WHEN $id IS NOT NULL THEN 'Edit a' ELSE 'Create a new' END || ' Security Profile') AS title,
    (SELECT CASE WHEN $id IS NOT NULL THEN 'Edit' ELSE 'Create' END) AS validate;

-- name
SELECT 
    'Name' as name,
    'Name' as label,
    'text' as type,
    1 as required,
    255 as maxlength,
    1 as autofocus,
    (SELECT CASE WHEN $id IS NOT NULL THEN Name ELSE '' END 
    FROM CoreSecurityProfile
    WHERE SecurityProfileId = $id::int OR $id IS NULL LIMIT 1) as value;

-- is admin
SELECT 
    'IsAdmin' as name,
    'Is Admin' as label,
    'checkbox' as type,
    (SELECT CASE WHEN $id IS NOT NULL THEN IsAdmin ELSE false END 
    FROM CoreSecurityProfile
    WHERE SecurityProfileId = $id::int OR $id IS NULL LIMIT 1) as checked;


-----
-- Security profile item
SELECT
    'divider' as component,
    'Security Item Rights' as contents,
    'left' as position,
    'blue' as color,
    4 as size,
    TRUE as bold
WHERE $id IS NOT NULL;

-- List
SELECT
    'table' as component,
    'action' as markdown,
    'CanRead' as icon,
    'CanWrite' as icon,
    'CanCreate' as icon,
    'CanDelete' as icon,
    'CanRead' as align_center,
    'CanWrite' as align_center,
    'CanCreate' as align_center,
    'CanDelete' as align_center,
    1 as striped_rows,
    1 as sort,
    1 as search
WHERE $id IS NOT NULL;
SELECT
    '[Delete](./securityprofileitemDelete.sql?id=' || SecurityProfileId || '&itemid=' || SecurityProfileItemId || ')' as Action,
    Name,
    SystemName,
    CASE CanRead WHEN true THEN 'check' ELSE '' END as CanRead,
    CASE CanWrite WHEN true THEN 'check' ELSE '' END as CanWrite,
    CASE CanCreate WHEN true THEN 'check' ELSE '' END as CanCreate,
    CASE CanDelete WHEN true THEN 'check' ELSE '' END as CanDelete
FROM CoreSecurityProfileItem
WHERE $id IS NOT NULL
AND SecurityProfileId = $id::int;


-- Security Item Form
SELECT 
    'form' AS component,
    './securityprofileitemInsert.sql' || COALESCE('?id=' || $id, '') as action,
    'Add a new Rights' AS title,
    'Add' AS validate
WHERE $id IS NOT NULL;


select 
    'SecurityItem' as name,
    'Security Item' as label,
    'select' as type,
    1 as required,
    'Select a Security Item...' as empty_option,
    (select json_agg(json_build_object(
        'label', 
        'QuestionnaireConfiguration#' || Name, 
        'value', 
        'QuestionnaireConfiguration#' || Name || '#' || QuestionnaireId)) 
     from ConfQuestionnaire) 
    as options,
    (select json_agg(json_build_object(
        'label', 
        'Questionnaire#' || Name, 
        'value', 
        'Questionnaire#' || Name || '#'  || QuestionnaireId)) 
     from ConfQuestionnaire) 
    as options;

-- can read
SELECT 
    'CanRead' as name,
    'Can Read' as label,
    'checkbox' as type,
    3 as width;

-- can write
SELECT 
    'CanWrite' as name,
    'Can Write' as label,
    'checkbox' as type,
    3 as width;

-- can create
SELECT 
    'CanCreate' as name,
    'Can Create' as label,
    'checkbox' as type,
    3 as width;

-- can delete
SELECT 
    'CanDelete' as name,
    'Can Delete' as label,
    'checkbox' as type,
    3 as width;