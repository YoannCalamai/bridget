-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-user.sql') as properties;


--INSERT if no id
DELETE FROM BudTransactionTag
WHERE $id IS NOT NULL AND TransactionTagId=$id::int;

SELECT 
    'redirect' AS component,
    './Transaction.sql?id=' || $cid as link;