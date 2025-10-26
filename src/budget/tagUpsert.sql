-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        './CategoriesTags.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT TagId FROM BudTag);

-- Upsert
INSERT INTO BudTag (TagId, Name) 
VALUES 
(       
        coalesce($id::int,(select coalesce(max(TagId),0) from BudTag) + 1),
        :Name
)
ON CONFLICT (TagId) DO 
UPDATE SET Name = excluded.Name
RETURNING
    'redirect' AS component,
    './CategoriesTags.sql' as link;