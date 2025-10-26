-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        './CategoriesTags.sql' AS link
WHERE coalesce($cid::int,0)>0 
AND $cid::int NOT IN (SELECT TagID FROM BudTag);

SELECT 'redirect' AS component,
        './CategoriesTags.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT TagAutoConfigurationId FROM BudTagAutoConfiguration);

-- Upsert
INSERT INTO BudTagAutoConfiguration (TagAutoConfigurationId, TagId, TransactionName, TransactionDescription) 
VALUES 
(       
        coalesce($id::int,(select coalesce(max(TagAutoConfigurationId),0) from BudTagAutoConfiguration) + 1),
        $cid::int,
        :TransactionName,
        :TransactionDescription
)
ON CONFLICT (TagAutoConfigurationId) DO 
UPDATE SET TransactionName = excluded.TransactionName
           TransactionDescription = excluded.TransactionDescription
RETURNING
    'redirect' AS component,
    './Tag.sql?id=' || $cid as link;