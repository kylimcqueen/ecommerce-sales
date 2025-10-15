-- =====================================================
-- sql/03_create_clean_tables.sql
-- =====================================================
-- Created by: Kyli McQueen
-- Create date: 10/15/2025
-- Description: Create clean versions of tables with 
--              invalid primary key values removed
-- =====================================================

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
CREATE TABLE amazonSales_clean AS
SELECT *
FROM amazonSales
WHERE "Order ID" IS NOT NULL 
  AND TRIM("Order ID") != ''
  AND SKU IS NOT NULL 
  AND TRIM(SKU) != ''
  AND Date IS NOT NULL;

-- INTERNATIONAL SALES
-- Remove rows with missing key fields AND non-product SKU values
CREATE TABLE internationalSales_clean AS
SELECT *
FROM internationalSales
WHERE SKU IS NOT NULL 
  AND TRIM(SKU) != ''
  AND DATE IS NOT NULL
  AND TRIM(DATE) != ''
  AND CUSTOMER IS NOT NULL
  AND TRIM(CUSTOMER) != ''
  -- Remove non-product entries 
  AND SKU NOT IN ('TAGS', 'TAGS(LABOUR)', 'TAG PRINTING', 'SHIPPING CHARGES', 'SHIPPING');

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