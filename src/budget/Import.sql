-- Check session
select 'dynamic' as component,
    sqlpage.run_sql('./include/sessioncheck-user.sql') as properties;

-- Page header/footer
select 'dynamic' as component,
    sqlpage.run_sql('include/shell-user.sql') as properties;

-- Navigation
select 
    'breadcrumb' as component;
select 
    'Home' as title,
    '/home.sql'    as link;
select 
    'Budget Home' as title,
    '/budget/BudgetHome.sql' as link;
select 
    'Import transactions' as title,
    '/budget/Import.sql' as link,
    TRUE   as active;

-- Display success message if file was uploaded
SELECT 'alert' AS component,
    'success' AS color,
    'Import Complete!' AS title,
    'Successfully imported ' || count(*)::TEXT || ' transactions from your CSV file.' AS description
FROM caisse_epargne_transactions
WHERE uploaded_file_id = $id::int
HAVING COUNT(*) > 0;

-- Display upload form
SELECT 'form' AS component,
    'Import Caisse Epargne Transactions' AS title,
    'Upload your CSV file with semicolon delimiters' AS description,
    './importaction_ce.sql' as action,
    'Import' as validate;
SELECT 'AccountId' AS name,
    'select' AS type,
    'Bank account' AS label,
    (
        SELECT json_agg(
                json_build_object('label', Name, 'value', AccountId)
            )
        FROM BudAccount
    ) as options,
    TRUE AS required;
SELECT 'csv_file' AS name,
    'file' AS type,
    'CSV File' AS label,
    '.csv' AS accept,
    TRUE AS required;

-- Display statistics
SELECT 'datagrid' AS component;
SELECT 'Transactions' AS title,
    COUNT(*)::TEXT AS description,
    'database' AS icon,
    'yellow' AS color
FROM caisse_epargne_transactions;
SELECT 'Total Debit' AS title,
    TO_CHAR(SUM(COALESCE(debit, 0)), 'FM999,999,999.00') || ' €' AS description,
    'trending-down' AS icon,
    'red' AS color
FROM caisse_epargne_transactions;
SELECT 'Total Credit' AS title,
    TO_CHAR(SUM(COALESCE(credit, 0)), 'FM999,999,999.00') || ' €' AS description,
    'trending-up' AS icon,
    'green' AS color
FROM caisse_epargne_transactions;
SELECT 'Balance' AS title,
    TO_CHAR(
        SUM(COALESCE(credit, 0)) + SUM(COALESCE(debit, 0)),
        'FM999,999,999.00'
    ) || ' €' AS description,
    'scale' AS icon,
    'blue' AS color
FROM caisse_epargne_transactions;

-- Show recent transactions
SELECT 'table' AS component,
    'Recent Transactions' AS title,
    TRUE AS sort,
    TRUE AS search,
    TRUE AS striped_rows;
SELECT TO_CHAR(date_comptabilisation, 'DD/MM/YYYY') AS "Date",
    libelle_simplifie AS "Name",
    libelle_operation as "Description",
    type_operation AS "Type",
    categorie AS "Category",
    sous_categorie AS "Sub-Category",
    CASE
        WHEN debit IS NOT NULL THEN TO_CHAR(debit, 'FM999,999,999.00') || ' €'
        ELSE ''
    END AS "Debit",
    CASE
        WHEN credit IS NOT NULL THEN '+' || TO_CHAR(credit, 'FM999,999,999.00') || ' €'
        ELSE ''
    END AS "Credit"
FROM caisse_epargne_transactions
ORDER BY date_comptabilisation DESC, id DESC
LIMIT 10000;