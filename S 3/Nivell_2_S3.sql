# NIVELL 2

# Exercici 1

CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_silver.products_clean` AS
SELECT
  id AS product_id,
  product_name AS name,
  price,
  colour,
  weight,
  CAST(REPLACE(warehouse_id, 'WH-', '') AS INT64) AS warehouse_id,
  category,
  brand,
  cost,
  launch_date
FROM
  `sprint3-analytics-xavi.sprint3_bronze.products_raw`;
  
  # Exercici 2
  
  CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_silver.transactions_clean` AS
SELECT
  id AS transaction_id,
  card_id,
  business_id,
  timestamp,
  IFNULL(SAFE_CAST(amount AS FLOAT64), 0) AS amount,
  declined,
  ARRAY(SELECT CAST(id AS INT64) FROM UNNEST(SPLIT(product_ids, ',')) AS id) AS product_ids,
  user_id,
  SAFE_CAST(lat AS FLOAT64) AS lat,
  SAFE_CAST(longitude AS FLOAT64) AS longitude
  
FROM `sprint3-analytics-xavi.sprint3_bronze.transactions_raw`;

# Exercici 3

CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_silver.users_combined` AS

SELECT
  SAFE_CAST(id AS INT64) AS user_id,
  name,
  surname,
  phone,
  email,
  birth_date,
  country,
  city,
  postal_code,
  address,
  'EUA' AS origin
FROM `sprint3-analytics-xavi.sprint3_bronze.american_users_raw`

UNION ALL

SELECT
  SAFE_CAST(id AS INT64) AS user_id,
  name,
  surname,
  phone,
  email,
  birth_date,
  country,
  city,
  postal_code,
  address,
  'Europa' AS origin
FROM `sprint3-analytics-xavi.sprint3_bronze.european_users_raw`;

# Exercici 4

CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_silver.companies_clean` AS
SELECT
  company_id,
  company_name,
  phone,
  email,
  country,
  website,
FROM
  `sprint3-analytics-xavi.sprint3_bronze.companies_raw`;
  
  CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_silver.credit_cards_clean` AS
SELECT
  id AS card_id,
  user_id,
  REPLACE(iban, ' ', '') AS iban,
  REPLACE(pan, ' ', '') AS pan,
  pin,
  cvv,
  track1,
  track2,
  expiring_date,
FROM
  `sprint3-analytics-xavi.sprint3_bronze.credit_cards_raw`;