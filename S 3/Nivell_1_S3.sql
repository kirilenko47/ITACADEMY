# NIVELL 1

# Exercici 1

CREATE SCHEMA IF NOT EXISTS `sprint3-analytics-xavier.sprint3_silver`
OPTIONS(
  location="EU"
);

# Exercici 2

CREATE OR REPLACE EXTERNAL TABLE `sprint3-analytics-xavi.sprint3_bronze.transactions_raw`
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/ERP/transactions.csv'],
  field_delimiter = ';',
  skip_leading_rows = 1
);

CREATE OR REPLACE EXTERNAL TABLE `sprint3-analytics-xavi.sprint3_bronze.companies_raw` (
  company_id STRING,
  company_name STRING,
  phone STRING,
  email STRING,
  country STRING,
  website STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/ERP/companies.csv'],
  skip_leading_rows = 1
);

CREATE OR REPLACE EXTERNAL TABLE `sprint3-analytics-xavi.sprint3_bronze.american_users_raw` (
  id STRING,
  name STRING,
  surname STRING,
  phone STRING,
  email STRING,
  birth_date STRING,
  country STRING,
  city STRING,
  postal_code STRING,
  address STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/CRM/american_users.csv'],
  skip_leading_rows = 1
);

CREATE OR REPLACE EXTERNAL TABLE `sprint3-analytics-xavi.sprint3_bronze.european_users_raw` (
  id STRING,
  name STRING,
  surname STRING,
  phone STRING,
  email STRING,
  birth_date STRING,
  country STRING,
  city STRING,
  postal_code STRING,
  address STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/CRM/european_users.csv'],
  skip_leading_rows = 1
);

CREATE OR REPLACE EXTERNAL TABLE `sprint3-analytics-xavi.sprint3_bronze.credit_cards_raw` (
  id STRING,
  user_id STRING,
  iban STRING,
  pan STRING,
  pin STRING,
  cvv STRING,
  track1 STRING,
  track2 STRING,
  expiring_date STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/CRM/credit_cards.csv'],
  skip_leading_rows = 1
);

# Exercici 4

CREATE OR REPLACE TABLE `sprint3-analytics-xavi.sprint3_bronze.transactions_raw_native` AS
SELECT *
FROM
  `sprint3-analytics-xavi.sprint3_bronze.transactions_raw`;
  
SELECT id FROM `sprint3-analytics-xavi.sprint3_bronze.transactions_raw_native`;

SELECT id FROM `sprint3-analytics-xavi.sprint3_bronze.transactions_raw`;

SELECT ID
FROM `sprint3-analytics-xavi.sprint3_bronze.transactions_raw`
LIMIT 10

SELECT ID
FROM `sprint3-analytics-xavi.sprint3_bronze.transactions_raw_native`
LIMIT 10

# Exercici 5

SELECT
  CAST(timestamp AS DATE) AS fecha_limpia,
  SUM(amount) AS ingresos_totales
FROM
  `sprint3-analytics-xavi.sprint3_bronze.transactions_raw_native`
WHERE
  EXTRACT(YEAR FROM CAST(timestamp AS DATE)) = 2021
GROUP BY
  fecha_limpia
ORDER BY
  ingresos_totales DESC
LIMIT 5;

# Exercici 6

SELECT t.timestamp AS transaction_date, c.company_name, c.country
FROM `sprint3-analytics-xavi`.`sprint3_bronze`.`transactions_raw_native` AS t
JOIN `sprint3-analytics-xavi`.`sprint3_bronze`.`companies_raw` AS c
  ON t.business_id = c.company_id
WHERE
  t.amount BETWEEN 100 AND 200
  AND DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY t.timestamp;



