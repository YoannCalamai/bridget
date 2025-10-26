-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Check input
SELECT 
    'redirect' AS component,
    './SecurityProfiles.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT SecurityProfileId FROM CoreSecurityProfile);

-- INSERT
INSERT INTO CoreSecurityProfileItem (SecurityProfileId, Name, SystemName, DbItemId, CanRead, CanWrite, CanCreate, CanDelete, CreatedBy, UpdatedBy)
VALUES 
(
    $id::int,
    split_part(:SecurityItem, '#', 2),
    split_part(:SecurityItem, '#', 1),
    split_part(:SecurityItem, '#', 3)::int,
    (CASE coalesce(:CanRead, 'false') WHEN 'false' THEN false ELSE true END)::BOOLEAN,
    (CASE coalesce(:CanWrite, 'false') WHEN 'false' THEN false ELSE true END)::BOOLEAN,
    (CASE coalesce(:CanCreate, 'false') WHEN 'false' THEN false ELSE true END)::BOOLEAN,
    (CASE coalesce(:CanDelete, 'false') WHEN 'false' THEN false ELSE true END)::BOOLEAN,
    (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session')),
    (SELECT UserId FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
)
RETURNING
    'redirect' AS component,
    './SecurityProfile.sql?id=' || SecurityProfileId || '&success=true' as link;