-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        '/home.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT TransactionId FROM BudTransaction);

-- Upsert
UPDATE BudTransaction
SET CategoryId=:CategoryId::int,
    SubCategoryId=:SubcategoryId::int
WHERE TransactionId=$id::int;

SELECT
    'redirect' AS component,
    '/home.sql' as link;