/*
 =====================================================
 sql/05_analysisViews.sql
 =====================================================
 Created by: Kyli McQueen
 Create date: 10/19/2025
 Description: Create views for each analysis question
 =====================================================
*/

--Question 1: How have sales performed over time?
--Question 2: When do sales peak and dip (seasonality)?
--Question 3: Which products drive revenue?
--Question 4: What are predicted sales for the next 6 months?

-- View 1: Monthly sales summary (Addresses questions 1 & 4 - trends & forecasting)
CREATE VIEW v_monthly_sales AS
SELECT 
    strftime('%Y-%m', sale_date) as year_month,
    COUNT(*) as transaction_count,
    SUM(sales_amount) as total_sales,
    AVG(sales_amount) as avg_order_value,
    SUM(quantity) as total_quantity
FROM unified_sales
GROUP BY strftime('%Y-%m', sale_date)
ORDER BY year_month;

-- View 2: Sales by month name (Addresses question 2 - seasonality)
CREATE VIEW v_sales_by_month AS
SELECT 
    strftime('%m', sale_date) as month_number,
    CASE strftime('%m', sale_date)
        WHEN '01' THEN 'January'
        WHEN '02' THEN 'February'
        WHEN '03' THEN 'March'
        WHEN '04' THEN 'April'
        WHEN '05' THEN 'May'
        WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'
        WHEN '08' THEN 'August'
        WHEN '09' THEN 'September'
        WHEN '10' THEN 'October'
        WHEN '11' THEN 'November'
        WHEN '12' THEN 'December'
    END as month_name,
    COUNT(*) as transaction_count,
    SUM(sales_amount) as total_sales,
    AVG(sales_amount) as avg_order_value
FROM unified_sales
GROUP BY strftime('%m', sale_date)
ORDER BY month_number;

-- View 3: Category performance (Addresses question 3)
CREATE VIEW v_category_performance AS
SELECT 
    p.Category,
    COUNT(DISTINCT s.sku) as unique_products,
    SUM(s.sales_amount) as total_sales,
    SUM(s.quantity) as total_quantity,
    AVG(s.sales_amount) as avg_transaction_value,
    COUNT(*) as transaction_count,
    ROUND(SUM(s.sales_amount) * 100.0 / (SELECT SUM(sales_amount) FROM unified_sales), 2) as pct_of_total_sales
FROM unified_sales s
JOIN productMaster_clean p ON s.sku = p."SKU Code"
GROUP BY p.Category
ORDER BY total_sales DESC;

-- View 4: Overall summary stats
CREATE VIEW v_summary_stats AS
SELECT 
    COUNT(*) as total_transactions,
    SUM(sales_amount) as total_revenue,
    AVG(sales_amount) as avg_transaction_value,
    MIN(sale_date) as first_sale,
    MAX(sale_date) as last_sale,
    COUNT(DISTINCT sale_date) as days_with_sales,
    COUNT(DISTINCT sku) as unique_products_sold
FROM unified_sales;

-------------------------------------------------------------------------------------------------
-- Sanity checks 

-- VIEW 1
-- Check monthly sales trend
SELECT * FROM v_monthly_sales;

-- I have about 12 months of  data
-- Overall sales amounts look reasonable, with values around millions per month
-- General upward trend in monthly sales  over time


--------------------------------------------------------------------------------------------------------------------------------
-- VIEW 2
-- Check seasonal patterns
SELECT * FROM v_sales_by_month;

-- I have exactly 12 rows of data, with each row representing one month of the year

-- Which months have highest sales?
--April, May and June have sales by far, but it is likely because these months contain data from 2021 and 2022 while the other months only
--contain data for one of the two years.

--------------------------------------------------------------------------------------------------------------------------------
-- VIEW 3
-- Check category breakdown
SELECT * FROM v_category_performance;

--Kurta set, kurta, and set are the categories with the highest total sales. They also have highest numbers of unique products.
-- They account for the highest percentages of overall sales.
--The item with the highest transaction value was lehenga choli, but it was only 0.65% of total sales.

-- Check what percentage of total sales each category makes up
SELECT 
	SUM(pct_of_total_sales) as total_percents
FROM v_category_performance

--Adding up all the percentages gives 95.53, so not all sales are represented in the data.
-- There are 19 total categories.

--Check which SKUs are missing since only 95% of categories are represented
-- Find SKUs in sales that aren't in productMaster
SELECT 
	--From unified sales, access all the SKU's
    s.sku,
	--Make a column showing how many transactions there are for each SKU
    COUNT(*) as transaction_count,
	--Find the total sales for each SKU
    SUM(s.sales_amount) as total_sales
FROM unified_sales s
LEFT JOIN productMaster_clean p ON s.sku = p."SKU Code"
--Only show SKU codes from unified sales if they are not in the product master
WHERE p."SKU Code" IS NULL
GROUP BY s.sku
ORDER BY total_sales DESC;

--Find what percent of total sales the missing SKU's represent
-- Calculate impact of missing SKUs
SELECT 
	-- Outer query 
    SUM(s.sales_amount) as sales_from_missing_skus,
	--Inner query - The sum of the sales_amount from unified sales is the total sales
    (SELECT SUM(sales_amount) FROM unified_sales) as total_sales,
    ROUND(SUM(s.sales_amount) * 100.0 / (SELECT SUM(sales_amount) FROM unified_sales), 2) as pct_of_total_sales,
    COUNT(DISTINCT s.sku) as missing_sku_count,
    COUNT(*) as transaction_count
FROM unified_sales s
LEFT JOIN productMaster_clean p ON s.sku = p."SKU Code"
WHERE p."SKU Code" IS NULL;
--Represents 4.7% of total sales

-- Check if missing SKUs are from specific channel/time
SELECT 
    channel,
    strftime('%Y-%m', sale_date) as year_month,
    COUNT(DISTINCT s.sku) as missing_sku_count,
    SUM(s.sales_amount) as total_sales
FROM unified_sales s
LEFT JOIN productMaster_clean p ON s.sku = p."SKU Code"
WHERE p."SKU Code" IS NULL
GROUP BY channel, year_month
ORDER BY year_month, channel;
--Mostly from Amazon channel, because highest numbers are during periods where we only have Amazon data
--------------------------------------------------------------------------------------------------------------------------------

-- VIEW 4
-- Check overall summary
SELECT * FROM v_summary_stats;
--Everything looks correct


