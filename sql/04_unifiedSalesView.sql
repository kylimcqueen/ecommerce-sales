/*
 =====================================================
 sql/04_unified_sales_view.sql
 =====================================================
 Created by: Kyli McQueen
 Create date: 10/15/2025
 Description: Combine amazonSales and internationalSales
              into one unified view for analysis
 =====================================================
*/

-- Drop existing view if it exists
DROP VIEW IF EXISTS unified_sales;

-- Create unified sales view with manual date parsing
CREATE VIEW unified_sales AS

-- Amazon sales (March-June 2022)
SELECT 
    "Order ID" as order_id,
    SKU as sku,
	sale_date,
    Qty as quantity,
    Amount as sales_amount,
    'Amazon' as channel,
    B2B as is_b2b,
    NULL as customer
FROM amazonSales_clean

UNION ALL

-- International sales (July 2021-May 2022)
SELECT 
    NULL as order_id,
    SKU as sku,
	sale_date,
    PCS as quantity,
    "GROSS AMT" as sales_amount,
    'International' as channel,
    NULL as is_b2b,
    CUSTOMER as customer
FROM internationalSales_clean;

/*
=====================================================
VERIFICATION
=====================================================
*/

-- Check the combined data
SELECT 
    channel,
    COUNT(*) as transaction_count,
    MIN(sale_date) as earliest_date,
    MAX(sale_date) as latest_date,
    SUM(sales_amount) as total_sales,
    AVG(sales_amount) as avg_transaction_value
FROM unified_sales
GROUP BY channel;

-- Check total rows
SELECT COUNT(*) as total_unified_rows FROM unified_sales;

-- Verify date range coverage
SELECT 
    MIN(sale_date) as earliest_sale,
    MAX(sale_date) as latest_sale,
    COUNT(DISTINCT sale_date) as unique_dates
FROM unified_sales;

/*
 =====================================================
 Sanity checks - Is there duplicate data between Amazon Sales and International Sales tables on 3/31/22?
 This is a fair question given the fact that another set of files in this dataset were duplicated data with different names.
 =====================================================
*/

-- SKUs sold for Amazon vs International Sales on 3/31/2022
SELECT 
	SKU,
	channel
FROM 
	unified_sales
WHERE sale_date = '2022-03-31'
ORDER BY SKU

-- # transactions for Amazon vs International Sales on 3/31/2025 - use individual tables
-- See if there are the same number of line items overall on this day
SELECT COUNT(*) as amazon_count_03_31_22
FROM amazonSales_clean
WHERE sale_date = '2022-03-31';
--171 sales

-- See if there are the same number of line items overall on this day
SELECT COUNT(*) as international_count_03_31_22
FROM internationalSales_clean
WHERE sale_date = '2022-03-31';
--46 sales



