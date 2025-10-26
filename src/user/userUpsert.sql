-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        './Users.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT UserId FROM CoreUser);

-- Upsert
INSERT INTO CoreUser (UserId, Firstname, Lastname, Username, Email, SecurityProfileId, LanguageId, PasswordHash, IsActive, CreatedBy, UpdatedBy) 
VALUES 
(       
        coalesce($id::int,(select coalesce(max(UserId),0) from CoreUser) + 1),
        :Firstname, 
        :Lastname, 
        :Email, 
        :Email,
        :SecurityProfileId::int,
        :LanguageId::int,
        coalesce(sqlpage.hash_password(:Password),sqlpage.hash_password(:Email)),
        (CASE coalesce(:IsActive, 'false') WHEN 'false' THEN false ELSE true END)::BOOLEAN,
        (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session')),
        (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
)
ON CONFLICT (UserId) DO 
UPDATE SET Firstname = excluded.Firstname,
        Lastname = excluded.Lastname,
        username = excluded.Email,
        Email = excluded.Email,
        SecurityProfileId = excluded.SecurityProfileId,
        LanguageId = excluded.LanguageId,
        IsActive = excluded.IsActive,
        UpdatedBy = (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session')),
        UpdatedAt = CURRENT_TIMESTAMP
RETURNING
    'redirect' AS component,
    './User.sql?id=' || UserId || '&success=0' as link;