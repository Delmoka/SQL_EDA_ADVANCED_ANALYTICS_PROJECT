/*============================
STEP 1 DATABASE EXPLORATION 
==============================*/
  
-- OBJECT EXPLORATION: Explore All Objects in the database 
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'DWAnalytics_Copy';


-- TABLES EXPLORATION: Explore all columns in all tables ( explore the information of the columns such as the names, data type etc)
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'DWAnalytics_Copy';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'DWAnalytics_Copy'
	AND TABLE_NAME = 'gold_dim_customers';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'DWAnalytics_Copy'
	AND TABLE_NAME = 'gold_dim_products';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'DWAnalytics_Copy'
  AND TABLE_NAME = 'gold_fact_sales';