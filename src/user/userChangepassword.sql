-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        './Users.sql' AS link
WHERE coalesce($id::int,0) <= 0;

-- Upsert
UPDATE CoreUser 
SET PasswordHash=sqlpage.hash_password(:Password), 
    PasswordLastUpdateAt=CURRENT_TIMESTAMP,
    UpdatedBy=(SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session')),
    UpdatedAt=CURRENT_TIMESTAMP
WHERE UserId=$id::int
RETURNING
    'redirect' AS component,
    './User.sql?id='|| $id ||'&successpwd' as link;