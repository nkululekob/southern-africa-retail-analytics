USE retail_sales;

-- 1. Drop the cleaned table if it already exists to start fresh
DROP TABLE IF EXISTS cleaned_retail_sales;

-- 2. Create the permanent cleaned table using a CTAS query
CREATE TABLE cleaned_retail_sales AS
SELECT 
    TRIM(transaction_id) AS transaction_id,
    
    -- Intelligently handles YYYY-MM-DD, YYYY/MM/DD, and DD/MM/YYYY formats
    -- and standardizes all of them into YYYY-MM-DD format
    CASE 
        WHEN TRIM(date) LIKE '____-__-%' THEN STR_TO_DATE(NULLIF(TRIM(date), 'N/A'), '%Y-%m-%d')
        WHEN TRIM(date) LIKE '____/__/__' THEN STR_TO_DATE(NULLIF(TRIM(date), 'N/A'), '%Y/%m/%d')
        WHEN TRIM(date) LIKE '__/__/____' THEN STR_TO_DATE(NULLIF(TRIM(date), 'N/A'), '%d/%m/%Y')
        ELSE NULL
    END AS transaction_date,
    
    -- Clean up whitespace in text fields
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    
    -- Ensure quantity is strictly positive (converts -2.0 or -2 into positive integer 2)
    ABS(CAST(NULLIF(TRIM(quantity), 'N/A') AS SIGNED)) AS quantity,
    
    -- Clean unit price, cast to precise decimal, and round to exactly 2 decimal places (e.g., 20.55)
    ROUND(
        CAST(NULLIF(TRIM(unit_price), 'N/A') AS DECIMAL(10, 4)), 
        2
    ) AS unit_price,
    
    -- Standardize currency codes to uppercase
    UPPER(TRIM(currency)) AS currency,
    
    -- Clean country names
    TRIM(country) AS country,
    
    -- Calculate total revenue, use positive quantities, and round to 2 decimal places (e.g., 20.55)
    ROUND(
        ABS(CAST(NULLIF(TRIM(quantity), 'N/A') AS SIGNED)) * 
        CAST(NULLIF(TRIM(unit_price), 'N/A') AS DECIMAL(10, 4)), 
        2
    ) AS total_revenue_zar

FROM raw_retail_sales
WHERE transaction_id IS NOT NULL 
  AND TRIM(transaction_id) <> '';

-- 3. Verify your newly cleaned data
SELECT * FROM cleaned_retail_sales LIMIT 15;