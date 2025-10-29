-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        './CategoriesTags.sql' AS link
WHERE coalesce($cid::int,0)>0 
AND $cid::int NOT IN (SELECT SubcategoryId FROM BudSubCategory);

SELECT 'redirect' AS component,
        './CategoriesTags.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT SubCategoryAutoConfigurationId FROM BudSubCategoryAutoConfiguration);

-- Upsert
INSERT INTO BudSubCategoryAutoConfiguration (SubCategoryAutoConfigurationId, SubCategoryId, TransactionName, TransactionDescription) 
VALUES 
(       
        coalesce($id::int,(select coalesce(max(SubCategoryAutoConfigurationId),0) from BudSubCategoryAutoConfiguration) + 1),
        $cid::int,
        :TransactionName,
        :TransactionDescription
)
ON CONFLICT (SubCategoryAutoConfigurationId) DO 
UPDATE SET TransactionName = excluded.TransactionName,
           TransactionDescription = excluded.TransactionDescription
RETURNING
    'redirect' AS component,
    './Subcategory.sql?id=' || $cid as link;