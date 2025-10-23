/*

sql/07_customerAnalysisViews.sql

Created by: Kyli McQueen
Create date: 10/22/2025
Description: Analysis views for customer questions.
1. What is our repeat customer rate?
2. Who are our highest-value customers?
3. What is the distribution of purchase frequency among customers?
4. Are there distinct customer segments based on purchasing behavior?
*/

-- View 1: Customer Purchase Frequency
DROP VIEW IF EXISTS v_intl_customer_frequency;

CREATE VIEW v_intl_customer_frequency AS
SELECT 
    CUSTOMER,
    COUNT(DISTINCT sale_date) as purchase_count,
    MIN(sale_date) as first_purchase,
    MAX(sale_date) as last_purchase,
    SUM("GROSS AMT") as total_spend,
    ROUND(SUM("GROSS AMT") / COUNT(DISTINCT sale_date), 2) as avg_order_value
FROM internationalSales_clean
GROUP BY CUSTOMER
ORDER BY purchase_count DESC;

-- View 2: Customer Lifetime Value (Top 50)
DROP VIEW IF EXISTS v_intl_customer_ltv;

CREATE VIEW v_intl_customer_ltv AS
SELECT 
    CUSTOMER,
    COUNT(DISTINCT sale_date) as purchase_count,
    SUM("GROSS AMT") as lifetime_value,
    ROUND(SUM("GROSS AMT") / COUNT(DISTINCT sale_date), 2) as avg_order_value
FROM internationalSales_clean
GROUP BY CUSTOMER
ORDER BY lifetime_value DESC
LIMIT 50;

-- View 3: Repeat vs One-Time Customers
DROP VIEW IF EXISTS v_intl_repeat_customers;

CREATE VIEW v_intl_repeat_customers AS
SELECT 
    CASE 
        WHEN purchase_days = 1 THEN 'One-Time'
        WHEN purchase_days BETWEEN 2 AND 3 THEN 'Occasional (2-3)'
        WHEN purchase_days BETWEEN 4 AND 6 THEN 'Regular (4-6)'
        ELSE 'Frequent (7+)'
    END as customer_type,
    COUNT(*) as customer_count,
    SUM(total_spend) as total_revenue,
    ROUND(AVG(total_spend), 2) as avg_customer_value
FROM (
    SELECT 
        CUSTOMER,
        COUNT(DISTINCT sale_date) as purchase_days,
        SUM("GROSS AMT") as total_spend
    FROM internationalSales_clean
    GROUP BY CUSTOMER
)
GROUP BY customer_type;

-- View 4: Customer Segmentation 
DROP VIEW IF EXISTS v_intl_customer_segments;

CREATE VIEW v_intl_customer_segments AS
SELECT 
    CUSTOMER,
    COUNT(DISTINCT sale_date) as purchase_frequency,
    SUM("GROSS AMT") as total_value,
    ROUND(SUM("GROSS AMT") / COUNT(DISTINCT sale_date), 2) as avg_order_value,
    CASE 
        WHEN SUM("GROSS AMT") >= 50000 AND COUNT(DISTINCT sale_date) >= 5 THEN 'High Value Frequent'
        WHEN SUM("GROSS AMT") >= 50000 AND COUNT(DISTINCT sale_date) < 5 THEN 'High Value Occasional'
        WHEN SUM("GROSS AMT") < 50000 AND COUNT(DISTINCT sale_date) >= 5 THEN 'Low Value Frequent'
        ELSE 'Low Value Occasional'
    END as segment
FROM internationalSales_clean
GROUP BY CUSTOMER;


--------------------------------------------------------------------------------------------------------
--Sanity checks

--See the ascending and descending list of total values
SELECT
	CUSTOMER,
	total_value
FROM
	v_intl_customer_segments
ORDER BY
	total_value DESC;
	
--------------------------------------------------------------------------------------------------------
-- See the distribution of customer lifetime values
SELECT 
    MIN(total_value) as min_value,
    MAX(total_value) as max_value,
    AVG(total_value) as avg_value,
    ROUND(AVG(total_value) * 1.5) as suggested_high_threshold
	COUNT(total_value>suggested_high_threshold)
FROM v_intl_customer_segments;
	
SELECT
	COUNT(total_value>suggested_high_threshold)
