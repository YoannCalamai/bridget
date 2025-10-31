-- Check session
select 'dynamic' as component, sqlpage.run_sql('./include/sessioncheck-user.sql') as properties;

-- Create temporary table for import
CREATE TEMPORARY TABLE IF NOT EXISTS temp_import (
    col1 TEXT, col2 TEXT, col3 TEXT, col4 TEXT, col5 TEXT,
    col6 TEXT, col7 TEXT, col8 TEXT, col9 TEXT, col10 TEXT,
    col11 TEXT, col12 TEXT, col13 TEXT
);

-- Step 1: Save uploaded file to uploaded_file table
INSERT INTO uploaded_file(name, data)
SELECT 
    sqlpage.uploaded_file_name('csv_file'),
    sqlpage.read_file_as_data_url(sqlpage.uploaded_file_path('csv_file'))
WHERE sqlpage.uploaded_file_path('csv_file') IS NOT NULL;

-- Step 2: Get the file id of the uploaded file
SET uploaded_file_id = (SELECT id FROM uploaded_file WHERE name=sqlpage.uploaded_file_name('csv_file'));

-- Step 3: Import transactions from the uploaded file into caisse_epargne transactions table
CALL import_caisse_epargne_from_uploaded($uploaded_file_id::int);

-- Step 4: Import categories that doesn't exist
INSERT INTO BudCategory (Name)
SELECT distinct categorie
FROM caisse_epargne_transactions
LEFT JOIN BudCategory on categorie = BudCategory.Name
WHERE uploaded_file_id=$uploaded_file_id::int
AND CategoryId is null;

-- Step 5: Import subcategories that doesn't exist
INSERT INTO BudSubCategory (Name)
SELECT distinct sous_categorie
FROM caisse_epargne_transactions
LEFT JOIN BudSubCategory on sous_categorie = BudSubCategory.Name
WHERE uploaded_file_id=$uploaded_file_id::int
AND SubCategoryId is null;

-- Step 6: Import transactions into app transactions table
INSERT INTO BudTransaction (AccountId, CategoryId, SubCategoryId, Date, Name, Description, Type, Value)
SELECT
    :AccountId::int,
    CategoryId,
    SubCategoryId,
    date_comptabilisation,
    libelle_simplifie,
    libelle_operation,
    type_operation,
    COALESCE(debit,credit)
FROM caisse_epargne_transactions
LEFT JOIN BudCategory on categorie = BudCategory.Name
LEFT JOIN BudSubCategory on sous_categorie = BudSubCategory.Name
WHERE uploaded_file_id=$uploaded_file_id::int;

-- -- Step 6: Import tags that doesn't exist
-- INSERT INTO BudTag (Name)
-- SELECT distinct sous_categorie
-- FROM caisse_epargne_transactions
-- LEFT JOIN BudTag on sous_categorie = BudTag.Name
-- WHERE uploaded_file_id=$uploaded_file_id::int
-- AND TagId is null;

-- -- Step 7: Assign tags to transactions
-- INSERT INTO BudTransactionTag (TagId, TransactionId)
-- SELECT TagId,
--        TransactionId
-- FROM caisse_epargne_transactions
-- JOIN BudTransaction on date_comptabilisation = BudTransaction.Date 
--                    AND libelle_simplifie = BudTransaction.Name
--                    AND type_operation = BudTransaction.Type
--                    AND COALESCE(debit,credit) = BudTransaction.Value
-- JOIN BudTag on sous_categorie = BudTag.Name
-- WHERE uploaded_file_id=$uploaded_file_id::int
-- AND AccountId=:AccountId::int;

-- Step 7: Apply categories autoconfiguration
UPDATE BudTransaction
SET CategoryId = cac.CategoryId
FROM BudCategoryAutoConfiguration cac
WHERE BudTransaction.Name = cac.TransactionName

-- Step 8: Apply subcategories autoconfiguration
UPDATE BudTransaction
SET SubCategoryId = cac.SubCategoryId
FROM BudSubCategoryAutoConfiguration cac
WHERE BudTransaction.Name = cac.TransactionName

-- Step 9: Apply tags autoconfiguration
--!! TODO




SELECT
    'redirect' AS component,
    './Import.sql?id=' || id as link
FROM uploaded_file
WHERE uploaded_file.name=sqlpage.uploaded_file_name('csv_file');


