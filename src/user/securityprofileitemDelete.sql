-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Check input
SELECT 
    'redirect' AS component,
    './SecurityProfiles.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT SecurityProfileId FROM CoreSecurityProfile);

SELECT 
    'redirect' AS component,
    './SecurityProfiles.sql' AS link
WHERE coalesce($itemid::int,0)>0 
AND $itemid::int NOT IN (SELECT SecurityProfileItemId FROM CoreSecurityProfileItem);

-- Delete
DELETE FROM CoreSecurityProfileItem 
WHERE SecurityProfileItemId=$itemid::int 
AND SecurityProfileId=$id::int
RETURNING
    'redirect' AS component,
    './SecurityProfile.sql?id=' || SecurityProfileId || '&success=true' as link;