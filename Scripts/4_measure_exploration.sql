/*-----------------------------------------------------------------------------------------------------------------
 MEASURES EXPLORATION
-------------------------------------------------------------------------------------------------------------------
    - TASKS
		- Find the total Sales 
        - find how many items are sold
        - Find the average selling price
        - Find the total number of orders
        - Find the total number of products
		- Find the total number of customers
		- Find the total number of customers that has palce an order
 -------------------------------------------------------------------------------------------------------------------*/       

-- Find the total Sales 
SELECT
SUM(sales_amount) AS total_sales
FROM gold_fact_sales;

-- find how many items are sold
SELECT 
SUM(quantity) AS tolal_item_sold
FROM gold_fact_sales;

-- Find the average selling price
SELECT 
AVG (price) AS AVG_selling_price
FROM  gold_fact_sales;

-- Find the total number of orders
SELECT 
COUNT(DISTINCT order_number) AS Total_order
FROM gold_fact_sales;

-- Find the total number of products
SELECT 
COUNT(product_key) AS total_number_of_product
FROM gold_dim_products;

-- Find the total number of customers
SELECT
COUNT(DISTINCT customer_key) AS total_customer
FROM gold_dim_customers; 

-- Find the total number of customers that has place an order
SELECT 
COUNT(DISTINCT customer_key) As total_customer_with_order
FROM gold_fact_sales;