/*
 =====================================================
 sql/05_analysisViews.sql
 =====================================================
 Created by: Kyli McQueen
 Create date: 10/17/2025
 Description: Create views for each analysis question
 =====================================================
*/

--Question 1: How have sales performed over time?
--Question 2: When do sales peak and dip (seasonality)?
--Question 3: Which products drive revenue?
--Question 4: How does Amazon perform vs international markets?
--Question 5: What are predicted sales for the next 6 months?

-- View 1: Monthly sales summary (Addresses questions 1 & 5 - trends & forecasting)
CREATE VIEW monthly_sales AS
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
CREATE VIEW sales_by_month AS
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
CREATE VIEW category_performance AS
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

-- View 4: Channel performance over time (Addresses question 4)
CREATE VIEW channel_performance AS
SELECT 
    strftime('%Y-%m', sale_date) as year_month,
    channel,
    COUNT(*) as transaction_count,
    SUM(sales_amount) as total_sales,
    AVG(sales_amount) as avg_order_value,
    SUM(quantity) as total_quantity
FROM unified_sales
GROUP BY strftime('%Y-%m', sale_date), channel
ORDER BY year_month, channel;

-- View 5: Overall summary stats
CREATE VIEW summary_stats AS
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
SELECT * FROM monthly_sales;

-- I have about 12 months of  data
-- Overall sales amounts look reasonable, with values around millions per month
-- General upward trend in monthly sales  over time


--------------------------------------------------------------------------------------------------------------------------------
-- VIEW 2
-- Check seasonal patterns
SELECT * FROM sales_by_month;

-- I have exactly 12 rows of data, with each row representing one month of the year

-- Which months have highest sales?
--April, May and June have sales by far, but it is likely because these months contain data from 2021 and 2022 while the other months only
--contain data for one of the two years.

--------------------------------------------------------------------------------------------------------------------------------
-- VIEW 3
-- Check category breakdown
SELECT * FROM category_performance;

--Kurta set, kurta, and set are the categories with the highest total sales. They also have highest numbers of unique products.
-- They account for the highest percentages of overall sales.
--The item with the highest transaction value was lehenga choli, but it was only 0.65% of total sales.

-- Check what percentage of total sales each category makes up
SELECT 
	SUM(pct_of_total_sales) as total_percents
FROM category_performance

--Adding up all the percentages gives 95.53, so not all sales are represented in the data.
-- There are 19 total categories.
--------------------------------------------------------------------------------------------------------------------------------

-- VIEW 4
-- Check overall summary
SELECT * FROM summary_stats;
--Everything looks correct


