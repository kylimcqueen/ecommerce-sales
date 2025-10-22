/*

sql/03_create_clean_tables.sql

Created by: Kyli McQueen
Create date: 10/22/2025
Description: Create clean versions of tables with invalid primary key values removed. I have 
updated amazonSales query, but not productMaster or internationalSales.

10/22/2025: amazonSales query - set all characters to uppercase for ship-city and ship-state columns. 
Removed blanks and nulls for these columns. Corrected naming anomalies in ship-state column.
*/

-- PRODUCT MASTER
-- Remove rows with missing SKU Code
CREATE TABLE productMaster_clean AS
SELECT *
FROM productMaster
--Remove nulls
WHERE "SKU Code" IS NOT NULL 
	--Remove blanks
  AND TRIM("SKU Code") != '';

-- AMAZON SALES
 -- Remove rows with missing Order ID or SKU
-- Format date column in an SQL-readable way
-- Clean ship-city COLUMN
-- Clean ship-state COLUMN

-- Drop the old table if creating a new version
DROP TABLE IF EXISTS amazonSales_clean_geo;
 
CREATE TABLE amazonSales_clean_geo AS
SELECT 
    "Order ID",
    SKU,
    UPPER("ship-city") as ship_city,
    -- Clean and standardize state names
    CASE 
        -- Fix ampersand formatting
        WHEN UPPER("ship-state") = 'JAMMU & KASHMIR' THEN 'JAMMU AND KASHMIR'
        WHEN UPPER("ship-state") = 'ANDAMAN & NICOBAR' THEN 'ANDAMAN AND NICOBAR ISLANDS'
        WHEN UPPER("ship-state") LIKE 'DADRA%NAGAR%' THEN 'DADRA AND NAGAR HAVELI AND DAMAN AND DIU'
        
        -- Fix New Delhi
        WHEN UPPER("ship-state") = 'NEW DELHI' THEN 'DELHI'
        
        -- Fix typos
        WHEN UPPER("ship-state") IN ('RAJSHTHAN', 'RAJSTHAN') THEN 'RAJASTHAN'
        WHEN UPPER("ship-state") = 'ORISSA' THEN 'ODISHA'
        WHEN UPPER("ship-state") = 'PONDICHERRY' THEN 'PUDUCHERRY'
        
        -- Fix abbreviations
        WHEN UPPER("ship-state") = 'RJ' THEN 'RAJASTHAN'
        WHEN UPPER("ship-state") = 'NL' THEN 'NAGALAND'
        WHEN UPPER("ship-state") = 'PB' THEN 'PUNJAB'
        WHEN UPPER("ship-state") IN ('AR', 'APO') THEN 'ANDHRA PRADESH'
        WHEN UPPER("ship-state") LIKE 'PUNJAB%MOHALI%' THEN 'PUNJAB'
        
        -- Keep everything else as-is (uppercased)
        ELSE UPPER("ship-state")
    END as ship_state,
    "ship-postal-code" as ship_postal_code,
    "ship-country" as ship_country,
    -- Format date 
    substr("Date", -4) || '-' ||  
    printf('%02d', CAST(substr("Date", 1, instr("Date", '/') - 1) AS INTEGER)) || '-' ||  
    printf('%02d', CAST(substr("Date", instr("Date", '/') + 1, 
                               instr(substr("Date", instr("Date", '/') + 1), '/') - 1) AS INTEGER)) AS sale_date,
	Style,
	Category,
	Size,
	"ASIN",
	Qty,
	currency,
	Amount,
	"promotion-ids",
	B2B
FROM amazonSales
WHERE "Order ID" IS NOT NULL 
  AND TRIM("Order ID") != ''
  AND SKU IS NOT NULL 
  AND TRIM(SKU) != '';
  
 -- INTERNATIONAL SALES
-- Remove rows with missing key fields AND non-product SKU values
-- Fomat date correctly
CREATE TABLE internationalSales_clean AS
SELECT 
    -- Create properly formatted date (using double quotes on "DATE")
    substr("DATE", -4) || '-' ||  
    printf('%02d', CAST(substr("DATE", 1, instr("DATE", '/') - 1) AS INTEGER)) || '-' ||  
    printf('%02d', CAST(substr("DATE", instr("DATE", '/') + 1, 
                               instr(substr("DATE", instr("DATE", '/') + 1), '/') - 1) AS INTEGER)) AS sale_date,
    CUSTOMER,
    Style,
    SKU,
    PCS,
    RATE,
    "GROSS AMT"
FROM internationalSales
WHERE SKU IS NOT NULL 
  AND TRIM(SKU) != ''
  AND "DATE" IS NOT NULL  -- Double quotes
  AND TRIM("DATE") != ''
  AND CUSTOMER IS NOT NULL
  AND TRIM(CUSTOMER) != ''
  AND SKU NOT IN ('TAGS', 'TAGS(LABOUR)', 'TAG PRINTING', 
                  'SHIPPING CHARGES', 'SHIPPING');

-- =====================================================
-- VERIFICATION: Check row counts
-- =====================================================

SELECT 'productMaster' as table_name,
       (SELECT COUNT(*) FROM productMaster) as original_rows,
       (SELECT COUNT(*) FROM productMaster_clean) as clean_rows,
	   --Subtract the removed rows of the original table from the total rows of the old table, make sure there is nothing left
       (SELECT COUNT(*) FROM productMaster) - (SELECT COUNT(*) FROM productMaster_clean) as rows_removed
       
UNION ALL

SELECT 'amazonSales' as table_name,
       (SELECT COUNT(*) FROM amazonSales) as original_rows,
       (SELECT COUNT(*) FROM amazonSales_clean) as clean_rows,
       (SELECT COUNT(*) FROM amazonSales) - (SELECT COUNT(*) FROM amazonSales_clean) as rows_removed
       
UNION ALL

SELECT 'internationalSales' as table_name,
       (SELECT COUNT(*) FROM internationalSales) as original_rows,
       (SELECT COUNT(*) FROM internationalSales_clean) as clean_rows,
       (SELECT COUNT(*) FROM internationalSales) - (SELECT COUNT(*) FROM internationalSales_clean) as rows_removed;

-- =====================================================
-- Sanity check: See date ranges for amazonSales_clean and internationalSales_clean
-- =====================================================

-- See date ranges for amazonSales_clean table
SELECT
	MIN(sale_date) AS earliest_sale,
	MAX(sale_date) AS latest_sale,
	COUNT(*) AS total_rows
FROM
	amazonSales_clean
	
--Earliest date 3/31/22 and latest date 6/29/22, as expected


-- See date ranges for internationalSales_clean table

SELECT
	MIN(sale_date) AS earliest_sale,
	MAX(sale_date) AS latest_sale,
	COUNT(*) AS total_rows
FROM
	internationalSales_clean
	
-- Earliest date 6/5/21 and latest date 3/31/22, different from date range prior to data cleaning
  