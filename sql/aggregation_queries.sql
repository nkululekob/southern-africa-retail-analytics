-- =====================================================================
-- Project: Southern Africa Retail Analytics
-- Script: Core Business & Performance Aggregation Queries
-- Database: retail_sales (Table: cleaned_retail_sales)
-- =====================================================================

USE retail_sales;

-- ---------------------------------------------------------------------
-- 1. Regional Performance: Total Revenue, Orders, & Share by Country
-- ---------------------------------------------------------------------
SELECT 
    country,
    COUNT(transaction_id) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(total_revenue_zar), 2) AS total_revenue_zar,
    ROUND(AVG(total_revenue_zar), 2) AS avg_transaction_value_zar,
    
    -- Calculates each country's percentage share of total corporate revenue
    ROUND(
        (SUM(total_revenue_zar) / (SELECT SUM(total_revenue_zar) FROM cleaned_retail_sales)) * 100, 
        2
    ) AS revenue_percentage_share

FROM cleaned_retail_sales
GROUP BY country
ORDER BY total_revenue_zar DESC;


-- ---------------------------------------------------------------------
-- 2. Category Performance: Sales Volume & Revenue Mix
-- ---------------------------------------------------------------------
SELECT 
    category,
    COUNT(transaction_id) AS transaction_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_revenue_zar), 2) AS category_revenue_zar,
    
    -- Calculates each category's share of overall revenue
    ROUND(
        (SUM(total_revenue_zar) / (SELECT SUM(total_revenue_zar) FROM cleaned_retail_sales)) * 100, 
        2
    ) AS category_revenue_share_pct

FROM cleaned_retail_sales
GROUP BY category
ORDER BY category_revenue_zar DESC;


-- ---------------------------------------------------------------------
-- 3. Temporal Trend: Monthly Sales Performance
-- ---------------------------------------------------------------------
SELECT 
    DATE_FORMAT(transaction_date, '%Y-%m') AS sales_month,
    COUNT(transaction_id) AS monthly_transactions,
    SUM(quantity) AS monthly_units_sold,
    ROUND(SUM(total_revenue_zar), 2) AS monthly_revenue_zar
FROM cleaned_retail_sales
WHERE transaction_date IS NOT NULL
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY sales_month ASC;


-- ---------------------------------------------------------------------
-- 4. Top 10 Products by Total Revenue Generation
-- ---------------------------------------------------------------------
SELECT 
    product_name,
    category,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(total_revenue_zar), 2) AS total_revenue_zar
FROM cleaned_retail_sales
GROUP BY product_name, category
ORDER BY total_revenue_zar DESC
LIMIT 10;