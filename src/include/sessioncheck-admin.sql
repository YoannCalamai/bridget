-- Check session and admin right
SELECT 
    'redirect' AS component,
    '/403' AS link
WHERE checkUserIsAdmin(sqlpage.cookie('session')) = false;