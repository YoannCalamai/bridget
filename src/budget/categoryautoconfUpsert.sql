-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        './CategoriesTags.sql' AS link
WHERE coalesce($cid::int,0)>0 
AND $cid::int NOT IN (SELECT CategoryId FROM BudCategory);

SELECT 'redirect' AS component,
        './CategoriesTags.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT CategoryAutoConfigurationId FROM BudCategoryAutoConfiguration);

-- Upsert
INSERT INTO BudCategoryAutoConfiguration (CategoryAutoConfigurationId, CategoryId, TransactionName, TransactionDescription) 
VALUES 
(       
        coalesce($id::int,(select coalesce(max(CategoryAutoConfigurationId),0) from BudCategoryAutoConfiguration) + 1),
        $cid::int,
        :TransactionName,
        :TransactionDescription
)
ON CONFLICT (CategoryAutoConfigurationId) DO 
UPDATE SET TransactionName = excluded.TransactionName,
           TransactionDescription = excluded.TransactionDescription
RETURNING
    'redirect' AS component,
    './Category.sql?id=' || $cid as link;