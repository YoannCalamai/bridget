-- Check session
select 'dynamic' as component, sqlpage.run_sql('./include/sessioncheck-user.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        '/home.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT id FROM uploaded_file);


DELETE FROM caisse_epargne_transactions WHERE uploaded_file_id=$id::int;
DELETE FROM uploaded_file WHERE id=$id::int;


SELECT
    'redirect' AS component,
    './Import.sql' as link;


