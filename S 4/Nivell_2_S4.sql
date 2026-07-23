# NIVELL 2

# Ejercicio 1

WITH VIP_Stats AS (
  SELECT user_id, SUM(amount) AS total_gastat, COUNT(transaction_id) AS num_compres, ROUND(AVG(amount), 2) AS tiquet_mig, MAX(amount) AS    max_compra
  FROM `sprint3-analytics-xavi.sprint3_silver.transactions_recent` t
  WHERE t.declined = 0
  GROUP BY user_id
  HAVING SUM(amount) > 500
)
SELECT u.user_id, CONCAT(u.name, ' ', u.surname) AS nom_complet, u.email, num_compres, tiquet_mig, max_compra, total_gastat
FROM VIP_Stats
JOIN `sprint3-analytics-xavi.sprint3_silver.users_combined` u 
ON VIP_Stats.user_id = u.user_id
ORDER BY total_gastat DESC;

# Ejercicio 2

WITH Ventas_Diarias AS (
  SELECT sales_date AS Data, total_sales AS Vendes_Avui, LAG(total_sales) OVER (ORDER BY sales_date) AS Vendes_Ahir
 FROM `sprint3-analytics-xavi.sprint3_gold.mv_daily_sales` 
)
SELECT Data, Vendes_Avui, Vendes_Ahir, ROUND((Vendes_Avui-Vendes_Ahir)/Vendes_Ahir*100,2) AS Diff_Percentual
FROM Ventas_Diarias;

# Ejercicio 3

SELECT 
  sales_date AS Data,ROUND(total_sales, 2) AS Vendes_del_Dia, ROUND(
    SUM(total_sales) OVER (
      PARTITION BY EXTRACT(YEAR FROM sales_date) 
      ORDER BY sales_date 
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 
  2) AS Vendes_Acumulades_YTD
FROM 
  `sprint3-analytics-xavi.sprint3_gold.mv_daily_sales`
ORDER BY Data;

# Ejercicio 4

WITH Primeres_Compres AS (
  SELECT 
    user_id,
    timestamp AS data_compra,
    amount,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY timestamp) AS num_compra
  FROM `sprint3-analytics-xavi.sprint3_silver.transactions_clean`
  WHERE declined = 0
  QUALIFY num_compra <= 3
),

Resum_Tercera_Compra AS (
  SELECT 
    user_id,
    data_compra AS data_3a_compra,
    amount AS import_3a_compra,
    ROUND(AVG(amount) OVER (PARTITION BY user_id), 2) AS mitjana_3_primeres
  FROM Primeres_Compres
  QUALIFY num_compra = 3
)

SELECT 
  u.user_id,
  CONCAT(u.name, ' ', u.surname) AS nom_complet,
  u.email,
  t.data_3a_compra,
  t.import_3a_compra,
  t.mitjana_3_primeres
FROM Resum_Tercera_Compra t
INNER JOIN `sprint3-analytics-xavi.sprint3_silver.users_combined` u
  ON t.user_id = u.user_id
ORDER BY t.mitjana_3_primeres DESC;