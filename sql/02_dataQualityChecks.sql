-- =====================================================
-- FILENAME: 02_data_quality_checks.sql
-- AUTHOR: Kyli McQueen
-- DATE: 10/15/2025
-- DESCRIPTION: Check for missing and invalid values
--              in primary key columns
-- =====================================================


--Check for nonsensical SKU values in productMaster
-- Check amazon_sales for blank/null Order_ID and SKU
SELECT 
	--Create a column with one cell  that counts the total number of rows in the table
    COUNT(*) as total_rows,
	--Create a column with one cell that holds the sum  of  blank or null Order IDs
    SUM(CASE WHEN "Order ID" IS NULL OR "Order ID" = '' THEN 1 ELSE 0 END) as blank_order_id,
	--Create a column with one cell that holds the sum of blank or null SKUs
    SUM(CASE WHEN SKU IS NULL OR SKU = '' THEN 1 ELSE 0 END) as blank_sku,
	--Create a column with one cell that holds the sum of blank or null values in Order ID and SKU columns
    SUM(CASE WHEN ("Order ID" IS NULL OR "Order ID" = '') OR (SKU IS NULL OR SKU = '') THEN 1 ELSE 0 END) as rows_to_delete
FROM amazonSales;

-- Look at examples of what will be deleted
SELECT *
FROM amazonSales
WHERE "Order ID" IS NULL 
   OR "Order ID" = ''
   OR SKU IS NULL 
   OR SKU = ''
LIMIT 20;

--Check for nonsensical SKU values in internationalSales
SELECT SKU, COUNT(*) as count
FROM internationalSales
WHERE SKU IN ('TAGS', 'TAGS(LABOUR)', 'TAG PRINTING', 'SHIPPING CHARGES', 'SHIPPING')
GROUP BY SKU;

-- Check international_sales for blank SKU, Date, Customer
SELECT 
    COUNT(*) as total_rows,
    SUM(CASE WHEN DATE IS NULL OR DATE = '' THEN 1 ELSE 0 END) as blank_date,
    SUM(CASE WHEN CUSTOMER IS NULL OR CUSTOMER = '' THEN 1 ELSE 0 END) as blank_customer,
    SUM(CASE WHEN SKU IS NULL OR SKU = '' THEN 1 ELSE 0 END) as blank_sku,
    SUM(CASE WHEN (DATE IS NULL OR DATE = '') OR (CUSTOMER IS NULL OR CUSTOMER = '') OR (SKU IS NULL OR SKU = '')  OR (SKU IN ('TAGS', 'TAGS(LABOUR)', 'TAG PRINTING', 'SHIPPING CHARGES', 'SHIPPING')) THEN 1 ELSE 0 END) as rows_to_delete
FROM internationalSales;


-- Look at examples
--Select all fields
SELECT *
FROM internationalSales
WHERE DATE IS NULL 
   OR DATE = ''
   OR CUSTOMER IS NULL 
   OR CUSTOMER = ''
   OR SKU IS NULL 
   OR SKU = ''
 --Show the first 20 results
LIMIT 20;

-- Check productMaster for blank SKU
SELECT 
    COUNT(*) as total_rows,
    SUM(CASE WHEN "SKU Code" IS NULL OR "SKU Code" = '' THEN 1 ELSE 0 END) as blank_sku,
    SUM(CASE WHEN ("SKU Code"  IS NULL OR "SKU Code" = '') THEN 1 ELSE 0 END) as rows_to_delete
FROM productMaster;

-- Look at examples
SELECT *
FROM productMaster
WHERE "SKU Code" IS NULL 
   OR "SKU Code" = ''
LIMIT 20;
