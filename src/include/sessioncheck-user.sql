-- Check session
SELECT 
    'redirect' AS component,
    '/Login.sql?error' AS link
WHERE (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session')) IS NULL;