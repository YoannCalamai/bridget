-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;


--INSERT if no id
INSERT INTO BudTransactionTag (TransactionId, TagId)
SELECT $cid::int, :TagId::int
WHERE $cid IS NOT NULL AND $id IS NULL;

--UPDATE if id
UPDATE BudTransactionTag
SET TagId=:TagId::int
WHERE $id IS NOT NULL AND TransactionTagId=$id::int;

SELECT 
    'redirect' AS component,
    './Transaction.sql?id=' || $cid as link;