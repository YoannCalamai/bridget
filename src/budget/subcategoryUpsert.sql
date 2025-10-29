-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        './CategoriesTags.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT SubCategoryId FROM BudSubCategory);

-- Upsert
INSERT INTO BudSubCategory (Name)
VALUES (:Name)
ON CONFLICT (Name) DO UPDATE SET Name = excluded.Name
RETURNING
    'redirect' AS component,
    './CategoriesTags.sql' as link;