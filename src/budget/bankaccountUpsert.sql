-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        './BankAccounts.sql' AS link
WHERE coalesce($id::int,0)>0 
AND $id::int NOT IN (SELECT AccountId FROM BudAccount);

-- Upsert
INSERT INTO BudAccount (AccountId, Name) 
VALUES 
(       
        coalesce($id::int,(select coalesce(max(AccountId),0) from BudAccount) + 1),
        :Name
)
ON CONFLICT (AccountId) DO 
UPDATE SET Name = excluded.Name
RETURNING
    'redirect' AS component,
    './BankAccounts.sql' as link;