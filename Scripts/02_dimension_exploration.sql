/* =================================================================================================================
   1) DIMENSION EXPLORATION
  ================================== 
     * CUSTOMER TABLES EXPLORATION 
		- explore All countries our customers come from
		- explore All marital status of our customers
		- explore All gender available 
-------------------------------------------------------------------------------------------------------------------*/

SELECT *
FROM gold_dim_customers;

SELECT 
DISTINCT country
FROM gold_dim_customers;

SELECT 
DISTINCT marital_status
FROM gold_dim_customers;

SELECT 
DISTINCT gender
FROM gold_dim_customers;

/*---------------------------------------------------------------------------------------------------------------------
 * PRODUCT TABLE EXPLORATION
	- explore All products categories
	- explore All products subcategories 
----------------------------------------------------------------------------------------------------------------------*/
 
SELECT *
FROM gold_dim_products;

SELECT 
DISTINCT category
FROM gold_dim_products;
  
SELECT 
DISTINCT subcategory
FROM gold_dim_products;

SELECT 
DISTINCT product_name
FROM gold_dim_products;

/*------------------------------------------------------------------------------------------------------------------
* SALES TABLES EXPLORATION
	- sales table contain mainly measure data 
-----------------------------------------------------------------------------------------------------------------*/
  
SELECT*
FROM gold_fact_sales;
