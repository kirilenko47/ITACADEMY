# NIVELL 1

# Exercici 1

SELECT *
FROM `sprint3_silver.transactions_clean` t
JOIN `sprint3_silver.companies_clean` c
ON t.business_id = c.company_id
WHERE 1=1 
AND c.country = 'Germany' 
AND DATE(t.timestamp) = '2022-03-12';

# Exercici 2

# Paso 1

CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_silver.transactions_recent` AS
SELECT 
  * EXCEPT(timestamp), 
  TIMESTAMP_SUB(
    CURRENT_TIMESTAMP(), 
    INTERVAL CAST(RAND() * 50 AS INT64) DAY
  ) AS timestamp
FROM 
  `sprint3-analytics-xavi.sprint3_silver.transactions_clean`;
  
# Paso 2

CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_gold.fact_transactions_optimized`
PARTITION BY 
  DATE(timestamp)
CLUSTER BY 
  business_id  
AS
SELECT 
  *
FROM 
  `sprint3-analytics-xavi.sprint3_silver.transactions_recent`;

# Ejercicio 3

# Paso 1

SELECT *
FROM sprint3_silver.transactions_recent
WHERE timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY);

# Paso 2

SELECT *
FROM sprint3_gold.fact_transactions_optimized
WHERE timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY);

# Ejercicio 4

CREATE MATERIALIZED VIEW `sprint3-analytics-xavi.sprint3_gold.mv_daily_sales` AS
SELECT 
  DATE(timestamp) AS sales_date,
  SUM(amount) AS total_sales
FROM 
  `sprint3-analytics-xavi.sprint3_gold.fact_transactions_optimized` 
GROUP BY 
  DATE(timestamp);




  
