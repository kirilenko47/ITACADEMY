# Ejercicio 1

CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_gold.dim_transactions_flat` AS
SELECT 
  t.transaction_id,
  t.timestamp,
  t.amount AS total_ticket_Global,
  p_id AS product_sku, 
  p.name AS product_name,
  p.price AS product_price
FROM 
  `sprint3-analytics-xavi.sprint3_silver.transactions_clean` t
CROSS JOIN 
  UNNEST(t.product_ids) AS p_id
LEFT JOIN 
  `sprint3-analytics-xavi.sprint3_silver.products_clean` p
ON 
  p_id = p.product_id;
  
  SELECT * FROM `sprint3-analytics-xavi.sprint3_gold.dim_transactions_flat` LIMIT 1000;
  
  # Ejercicio 2
  
  SELECT 
  product_sku,
  product_name,
  COUNT(*) AS total_unitats_venudes
FROM 
  `sprint3-analytics-xavi.sprint3_gold.dim_transactions_flat`
GROUP BY 
  product_sku,
  product_name
ORDER BY 
  total_unitats_venudes DESC
LIMIT 5;


  SELECT 
  product_name,
  COUNT(*) AS total_unitats_venudes
FROM 
  `sprint3-analytics-xavi.sprint3_gold.dim_transactions_flat`
GROUP BY 
  product_name
ORDER BY 
  total_unitats_venudes DESC
LIMIT 5;

# Ejercicio 3

CREATE OR REPLACE FUNCTION `sprint3-analytics-xavi.sprint3_gold.calculate_tax`(amount FLOAT64)
RETURNS FLOAT64 AS (
  amount * 1.21
);

CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_gold.dim_transactions_flat` AS
SELECT 
  t.transaction_id,
  t.timestamp,
  t.amount AS total_ticket_Global,
  p.product_id AS product_sku,
  p.name AS product_name,
  p.price AS product_price,
  
  `sprint3-analytics-xavi.sprint3_gold.calculate_tax`(p.price) AS product_price_tax_inc

FROM 
  `sprint3-analytics-xavi.sprint3_silver.transactions_clean` t
CROSS JOIN 
  UNNEST(t.product_ids) AS id_producto
LEFT JOIN 
  `sprint3-analytics-xavi.sprint3_silver.products_clean` p 
  ON id_producto = p.product_id
WHERE 
  t.declined = 0;


