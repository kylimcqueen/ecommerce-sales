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
    -- Convert M/D/YYYY to YYYY-MM-DD format
    substr(Date, -4) || '-' ||  
    printf('%02d', CAST(substr(Date, 1, instr(Date, '/') - 1) AS INTEGER)) || '-' ||  
    printf('%02d', CAST(substr(Date, instr(Date, '/') + 1, 
                               instr(substr(Date, instr(Date, '/') + 1), '/') - 1) AS INTEGER)) as sale_date,
    Qty as quantity,
    Amount as sales_amount,
    'Amazon' as channel,
    B2B as is_b2b,
    NULL as customer,
    Fulfilment as fulfillment_method
FROM amazonSales_clean

UNION ALL

-- International sales (July 2021-May 2022)
SELECT 
    NULL as order_id,
    SKU as sku,
    -- Convert M/D/YYYY to YYYY-MM-DD format
    substr(DATE, -4) || '-' ||  
    printf('%02d', CAST(substr(DATE, 1, instr(DATE, '/') - 1) AS INTEGER)) || '-' ||  
    printf('%02d', CAST(substr(DATE, instr(DATE, '/') + 1, 
                               instr(substr(DATE, instr(DATE, '/') + 1), '/') - 1) AS INTEGER)) as sale_date,
    PCS as quantity,
    "GROSS AMT" as sales_amount,
    'International' as channel,
    NULL as is_b2b,
    CUSTOMER as customer,
    NULL as fulfillment_method
FROM internationalSales_clean;

=====================================================
VERIFICATION
=====================================================

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