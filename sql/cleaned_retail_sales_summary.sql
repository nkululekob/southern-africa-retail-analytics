USE retail_sales;
DROP TABLE IF EXISTS cleaned_retail_sales_summary;
-- Create a permanent summary table using CTAS (Create Table As Select)
CREATE TABLE cleaned_retail_sales_summary AS

-- Step 1: Clean raw strings, handle placeholders, and cast data types safely
WITH cleaned_base AS (
    SELECT 
        transaction_id,
        -- Convert text placeholders like 'N/A' into actual SQL NULLs for the date field
        NULLIF(TRIM(date), 'N/A') AS clean_date,
        
        -- Standardize text casing and remove leading/trailing whitespace
        UPPER(TRIM(country)) AS country,
        TRIM(category) AS category,
        TRIM(product_name) AS product_name,
        
        -- Convert quantity to numeric and convert negative returns into positive values using ABS()
        ABS(CAST(NULLIF(NULLIF(TRIM(quantity), 'N/A'), '') AS DECIMAL(10, 2))) AS quantity_cleaned,
        
        -- Convert unit price to decimal numbers, safely handling empty or placeholder strings
        CAST(NULLIF(NULLIF(TRIM(unit_price), 'N/A'), '') AS DECIMAL(10, 2)) AS unit_price,
        
        -- Standardize currency code casing
        UPPER(TRIM(currency)) AS currency
    FROM raw_retail_sales
),

-- Step 2: Normalize multi-currency transactions into a single unified currency (ZAR)
currency_normalized AS (
    SELECT 
        transaction_id,
        country,
        category,
        product_name,
        quantity_cleaned,
        unit_price,
        currency,
        
        -- Calculate total revenue and convert foreign currencies to South African Rand (ZAR) via CASE lookup
        quantity_cleaned * unit_price * 
        CASE currency
            WHEN 'ZAR' THEN 1.0
            WHEN 'BWP' THEN 1.35
            WHEN 'NAD' THEN 1.0
            WHEN 'ZMW' THEN 0.70
            WHEN 'USD' THEN 18.50
            ELSE 1.0  -- Default fallback multiplier if currency is unrecognized
        END AS total_revenue_zar
    FROM cleaned_base
)

-- Step 3: Aggregate metrics by country and category, rounding financial figures to 2 decimal places
SELECT 
    country,
    category,
    COUNT(transaction_id) AS total_transactions,
    SUM(quantity_cleaned) AS total_quantity_sold,
    ROUND(SUM(total_revenue_zar), 2) AS total_revenue_zar,
    ROUND(AVG(total_revenue_zar), 2) AS avg_revenue_zar
FROM currency_normalized
GROUP BY country, category;

SELECT * FROM cleaned_retail_sales_summary LIMIT 15