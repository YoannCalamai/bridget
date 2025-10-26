-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Check input
SELECT 
    'redirect' AS component,
    './home.sql' AS link
WHERE (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))>0 
AND (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session')) NOT IN (SELECT UserId FROM CoreUser);

-- Update
UPDATE CoreUser SET 
    Firstname = :Firstname,
    Lastname = :Lastname,
    username = :Email,
    Email = :Email,
    LanguageId = :LanguageId::int,
    UpdatedBy = (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session')),
    UpdatedAt = CURRENT_TIMESTAMP
WHERE UserId = (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
RETURNING
    'redirect' AS component,
    './MyProfile.sql?success=0' as link;