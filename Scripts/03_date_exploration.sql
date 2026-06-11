/*------------------------------------------------------------------------------------------------------------------------------
 DATE EXPLORATION
		- view three tables and see where we can explore the dates 
		- from our customers tables we can explore the birthday to find out the youngest and oldest customers 
        - from our product table, the only date column available is the start_date ( which is the date that the product is register ) so no date to explore 
        - from our sales table, we have order_date, shipping_date and due_date. so our date exploration will happen on the sales table.
-----------------------------------------------------------------------------------------------------------------*/
    
-- TABLES SELECTION 
SELECT *
FROM gold_dim_customers; 

SELECT *
FROM gold_dim_products;

SELECT *
FROM gold_fact_sales;

-- SALES TABLE EXPLORATION: 
	-- TASK1: find the date of the first and last order 
	-- TASK2: find the number of years of sales available  

 SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    YEAR(MAX(order_date)) - YEAR(MIN(order_date)) AS order_range_years
FROM gold_fact_sales;
