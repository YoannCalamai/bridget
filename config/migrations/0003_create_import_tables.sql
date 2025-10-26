-- Create the uploaded_file table if it doesn't exist
CREATE TABLE IF NOT EXISTS uploaded_file (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    data TEXT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS caisse_epargne_transactions (
    id SERIAL PRIMARY KEY,
    date_comptabilisation DATE,
    libelle_simplifie TEXT,
    libelle_operation TEXT,
    reference TEXT,
    informations_complementaires TEXT,
    type_operation TEXT,
    categorie TEXT,
    sous_categorie TEXT,
    debit DECIMAL(10,2),
    credit DECIMAL(10,2),
    date_operation DATE,
    date_valeur DATE,
    pointage_operation INTEGER,
    uploaded_file_id INTEGER,
    imported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create temporary table for import
CREATE TEMPORARY TABLE IF NOT EXISTS temp_import (
    col1 TEXT, col2 TEXT, col3 TEXT, col4 TEXT, col5 TEXT,
    col6 TEXT, col7 TEXT, col8 TEXT, col9 TEXT, col10 TEXT,
    col11 TEXT, col12 TEXT, col13 TEXT
);


-- This procedure reads CSV data from uploaded_file table and imports into caisse_epargne_transactions
CREATE OR REPLACE PROCEDURE import_caisse_epargne_from_uploaded(p_uploaded_file_id INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    v_file_data TEXT;
    v_csv_content TEXT;
    v_line TEXT;
    v_lines TEXT[];
    v_fields TEXT[];
    v_line_num INTEGER := 0;
BEGIN
    -- Get the data URL from uploaded_file table
    SELECT data INTO v_file_data
    FROM uploaded_file
    WHERE id = p_uploaded_file_id;
    
    IF v_file_data IS NULL THEN
        RETURN;
    END IF;
    
    -- Decode the data URL (format: data:text/csv;base64,...)
    -- Extract base64 part after the comma
    v_csv_content := convert_from(
        decode(
            substring(v_file_data from 'base64,(.*)$'),
            'base64'
        ),
        'UTF8'
    );
    
    -- Split content into lines
    v_lines := string_to_array(v_csv_content, E'\n');
    
    -- Process each line (skip header line)
    FOREACH v_line IN ARRAY v_lines
    LOOP
        v_line_num := v_line_num + 1;
        
        -- Skip header and empty lines
        IF v_line_num = 1 OR trim(v_line) = '' THEN
            CONTINUE;
        END IF;
        
        -- Split line by semicolon
        v_fields := string_to_array(v_line, ';');
        
        -- Skip if not enough fields
        IF array_length(v_fields, 1) < 13 THEN
            CONTINUE;
        END IF;
        
        -- Insert into transactions table with conversions
        INSERT INTO caisse_epargne_transactions (
            uploaded_file_id,
            date_comptabilisation,
            libelle_simplifie,
            libelle_operation,
            reference,
            informations_complementaires,
            type_operation,
            categorie,
            sous_categorie,
            debit,
            credit,
            date_operation,
            date_valeur,
            pointage_operation
        ) VALUES (
            p_uploaded_file_id,
            TO_DATE(v_fields[1], 'DD/MM/YYYY'),
            v_fields[2],
            v_fields[3],
            v_fields[4],
            v_fields[5],
            v_fields[6],
            v_fields[7],
            v_fields[8],
            CASE WHEN trim(v_fields[9]) != '' THEN REPLACE(v_fields[9], ',', '.')::DECIMAL ELSE NULL END,
            CASE WHEN trim(v_fields[10]) != '' THEN REPLACE(v_fields[10], ',', '.')::DECIMAL ELSE NULL END,
            TO_DATE(v_fields[11], 'DD/MM/YYYY'),
            TO_DATE(v_fields[12], 'DD/MM/YYYY'),
            COALESCE(NULLIF(trim(v_fields[13]), ''), '0')::INTEGER
        );
    END LOOP;
END;
$$;