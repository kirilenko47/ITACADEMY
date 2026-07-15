# NIVELL 3

# Exercici 1

CREATE OR REPLACE VIEW `sprint3-analytics-xavi.sprint3_gold.v_marketing_kpis` AS
SELECT
  c.company_name,
  c.phone,
  c.country,
  ROUND(AVG(t.amount), 2) AS avg_purchase_amount,
  CASE
    WHEN AVG(t.amount) > 260 THEN 'Premium'
    ELSE 'Standard'
  END AS Client_tier
FROM
  `sprint3-analytics-xavi.sprint3_silver.companies_clean` c
JOIN
  `sprint3-analytics-xavi.sprint3_silver.transactions_clean` t
ON
  c.company_id = t.business_id
GROUP BY
  c.company_name,
  c.phone,
  c.country;

SELECT *
FROM
  `sprint3-analytics-xavi.sprint3_gold.v_marketing_kpis`
ORDER BY
  client_tier ASC,
  avg_purchase_amount DESC;
  
# Exercici 2

CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_gold.product_sales_ranking` AS
WITH flattened_transactions AS (
  SELECT
    transaction_id,
    id_producte_venut
  FROM
    `sprint3-analytics-xavi.sprint3_silver.transactions_clean`,
    UNNEST(product_ids) AS id_producte_venut)
SELECT
  p.product_id,
  p.name,
  p.price,
  p.colour,
  COUNT(ft.id_producte_venut) AS total_sold
FROM
  `sprint3-analytics-xavi.sprint3_silver.products_clean` p
LEFT JOIN
  flattened_transactions ft
ON
  p.product_id = ft.id_producte_venut
GROUP BY
  p.product_id,
  p.name,
  p.price,
  p.colour
ORDER BY
  total_sold DESC;