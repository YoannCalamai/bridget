-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Check input
SELECT 
    'redirect' AS component,
    './SecurityProfiles.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT SecurityProfileId FROM COreSecurityProfile);

-- Upsert
INSERT INTO CoreSecurityProfile (SecurityProfileId, Name, IsAdmin, CreatedBy, UpdatedBy)
VALUES 
(
    coalesce($id::int,(select coalesce(max(SecurityProfileId),0) from CoreSecurityProfile) + 1),
    substr(:Name, 1, 255),
    (CASE coalesce(:IsAdmin, 'false') WHEN 'false' THEN false ELSE true END)::BOOLEAN,
    (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session')),
    (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
)
ON CONFLICT (SecurityProfileId) DO 
UPDATE SET 
    Name = excluded.Name,
    IsAdmin = excluded.IsAdmin,
    UpdatedBy = (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session')),
    UpdatedAt = current_timestamp
RETURNING
    'redirect' AS component,
    './SecurityProfile.sql?id=' || SecurityProfileId || '&success=true' as link;