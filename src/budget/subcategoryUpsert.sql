-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;


--INSERT if no id
INSERT INTO BudSubCategory (Name)
SELECT :Name
WHERE $id IS NULL;

--UPDATE if id
UPDATE BudSubCategory
SET Name=:Name
WHERE $id IS NOT NULL AND SubCategoryId=$id::int;

SELECT 
    'redirect' AS component,
    './CategoriesTags.sql' as link;