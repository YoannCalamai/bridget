-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;


--INSERT if no id
INSERT INTO BudTag (Name)
SELECT :Name
WHERE $id IS NULL;

--UPDATE if id
UPDATE BudTag
SET Name=:Name
WHERE $id IS NOT NULL AND TagId=$id::int;

SELECT 
    'redirect' AS component,
    './CategoriesTags.sql' as link;