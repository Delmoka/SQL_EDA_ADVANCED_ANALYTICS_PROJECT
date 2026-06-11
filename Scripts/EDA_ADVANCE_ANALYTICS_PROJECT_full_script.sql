
/*=========================================================================================================
EXPLORATORY DATA ANALYSIS AND ADVANCE ANALYTICS PROJECT
======================================================
======================================================
I) EXPLORATORY DATA ANALYSIS (EDA)
================================= 
  
STEP 1 DATABASE EXPLORATION 
*/
  
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
  
/* =================================================================================================================
STEP 2: ACTUAL DATA (BUSINESS DATA) EXPLORATION
------------------------------------------------------------------------------------------------------------------
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

/*------------------------------------------------------------------------------------------------------------------------------
* DATE EXPLORATION
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

/*-----------------------------------------------------------------------------------------------------------------
-- 2) MEASURES EXPLORATION
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

/*===================================================================================
 KEY METRICS REPORT 
====================================================================================
	PURPOSE: GENERATE A REPORT THAT SHOWS ALL KEY METRICS OF THE BUSINESS 
			- WE HAVE 2 OPTIONS : PUTTING ALL THE INDIVISUAL QUERIES IN ONE BIG QUERY OR USING UNION ALL : The UNION ALL OPTION IS MORE PRRESENTABLE IN A REPORT
----------------------------------------------------------------------------------- */
 
   -- OPTION 1: USING ONE BIG QUERY
 SELECT
    (SELECT SUM(sales_amount)
     FROM gold_fact_sales) AS total_sales,

    (SELECT SUM(quantity)
     FROM gold_fact_sales) AS total_items_sold,

    (SELECT AVG(price)
     FROM gold_fact_sales) AS avg_selling_price,

    (SELECT COUNT(DISTINCT order_number)
     FROM gold_fact_sales) AS total_orders,

    (SELECT COUNT(product_key)
     FROM gold_dim_products) AS total_products,

    (SELECT COUNT(DISTINCT customer_key)
     FROM gold_dim_customers) AS total_customers,

    (SELECT COUNT(DISTINCT customer_key)
     FROM gold_fact_sales) AS customers_with_orders;
     
     
   -- OPTION 2: USING UNION ALL 
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value
FROM gold_fact_sales

UNION ALL

SELECT 'Total Quantity', SUM(quantity)
FROM gold_fact_sales

UNION ALL

SELECT 'Average Price', AVG(price)
FROM gold_fact_sales

UNION ALL

SELECT 'Total Orders', COUNT(DISTINCT order_number)
FROM gold_fact_sales

UNION ALL

SELECT 'Total Products', COUNT(product_key)
FROM gold_dim_products

UNION ALL

SELECT 'Total Customers', COUNT(customer_key)
FROM gold_dim_customers

UNION ALL

SELECT 'Customers With Orders', COUNT(DISTINCT customer_key)
FROM gold_fact_sales;

/*---------------------------------------------------------------------------------------------------------
3) MAGNITUDE ANALYSIS 
	-- PURPOSE: group data by category for comparaison pusposes. comparing categories allows us to define the best ot highest contributor and the lowest and worst contributor to the whole data
------------------------------------------------------------------------------------------------------------*/
   
   -- TASK1 : Find the total number of customers by countries
SELECT 
country,
COUNT(customer_id )As total_number_of_customer
FROM gold_dim_customers
GROUP BY country
ORDER BY total_number_of_customer DESC;

-- TASK2 : Find total customer by gender 
SELECT
gender,
COUNT(customer_id) AS total_number_by_gender
FROM gold_dim_customers
GROUP BY gender
ORDER BY total_number_by_gender DESC;

-- TASK3 : Find total product by category 
SELECT
category,
COUNT(product_key) AS total_product
FROM gold_dim_products
GROUP BY category
ORDER BY total_product DESC;

-- TASK4 :Calculate the average cost in each category 
SELECT
category,
AVG (cost) AS AVG_cost
FROM gold_dim_products
GROUP BY category
ORDER BY AVG_cost DESC;

-- TASK5: Calculate total revenue by category
SELECT 
p.category,
SUM(s.sales_amount) AS total_revenue
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category 
ORDER BY total_revenue DESC;

-- TASK6: Calculate total revenue generated by each customer 
SELECT
s.customer_key,
c.first_name,
c.last_name,
SUM(sales_amount) As total_revenue
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY 
s.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC;

-- TASK7 : Calculate total items or quantity sold by country
SELECT
c.country,
SUM(s.quantity) AS total_item
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_customers As c
ON s.customer_key = s.customer_key
GROUP BY country
ORDER BY total_item DESC;
/*====================================
RANKING ANALYSIS 
========================================
	PURPOSE : to allow us rank our values to see the top and bottom performers in our data 
--------------------------------------------------------------------------------------------------- */

-- TASK1 : WHICH 5 PRODUCTS GENERATED THE HIGHEST RVENUE?
SELECT 
p.product_name,
SUM(s.sales_amount) AS total_revenue
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_name 
ORDER BY total_revenue DESC
LIMIT 5;

-- TASK2 : WHAT IS THE 5 WORST PERFORMING PRODUCTS BY SALES 
SELECT 
p.product_name,
SUM(s.sales_amount) AS total_revenue
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_name 
ORDER BY total_revenue ASC
LIMIT 5;

/*======================================================================================================================
II) ADVANCE DATA ANALYTICS 
		- this process uses advance queries and techniques to answer business questions.
-----------------------------------------------------------------------------------------------------------------------

   1) CHANGES OVERTIME ANALYSIS ( this allows us to analyse our measures overtime to see any trend) */

-- TASK1 : ANALYZE SALES PERFORMANCE OVERTIME 
SELECT
order_date,
sales_amount
FROM gold_fact_sales
WHERE order_date IS NOT NULL
ORDER BY order_date ASC;
-- This provides sales by day
  
SELECT
	order_date,
	SUM(sales_amount) AS total_sales
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date ASC;
-- This aggregate ( provides total sales by day). 

SELECT
	DATE_FORMAT(order_date, '%Y- %M') AS order_month,
	SUM(sales_amount) AS total_sales,
    COUNT( DISTINCT customer_key) AS total_customer,
    SUM(quantity) AS total_quantity_sold,
    ROUND(AVG(price),'0') AS AVG_price
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y- %M')
ORDER BY DATE_FORMAT(order_date, '%Y- %M') ASC;
-- This aggregate ( provides total sales, total customers etc, total quantity sold per month). 

SELECT
	DATE_FORMAT(order_date, '%Y') AS order_year,
	SUM(sales_amount) AS total_sales,
    COUNT( DISTINCT customer_key) AS total_customer,
    SUM(quantity) AS total_quantity_sold,
    ROUND(AVG(price),'0') AS AVG_price
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y')
ORDER BY DATE_FORMAT(order_date, '%Y') ASC;
-- This aggregate ( provides total sales, total customers, total quantity sold per year). 

/*----------------------------------------------------------------------------------------------------------------------------
2)  CUMULATIVE ANALYSIS ( this analysis helps us see the evolution of the business through time . like overall sales from start of the year to the end of the year. 
		-- WE USE RUNNING TOTALS AND MOVING AVERAGE
-------------------------------------------------------------------------------------------------------------------------------*/

-- TASK: CALCULATE THE TOTAL SALES PER MONTH AND THE RUNNING TOTAL OF SALES OVER TIME
SELECT 
	order_month, 
	monthly_sales, 
    SUM(monthly_sales) OVER (ORDER BY order_month ASC) AS monthly_running_total
FROM
(
SELECT 
	DATE_FORMAT(order_date, '%Y- %m') AS order_month,
    SUM(sales_amount) AS monthly_sales
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y- %m')
ORDER BY DATE_FORMAT(order_date, '%Y- %m')) AS t 
;
-- this provides us with cummulative total sales from the first year to the last year

SELECT 
	order_month, -- dont try to select DATE_FORMAT(order_date, '%Y- %m') AS order_month 
	monthly_sales, -- same scenario
    SUM(monthly_sales) OVER (PARTITION BY order_month ORDER BY order_month ASC) AS monthly_running_total
FROM
(
SELECT 
	DATE_FORMAT(order_date, '%Y- %m') AS order_month,
    SUM(sales_amount) AS monthly_sales
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y- %m')
ORDER BY DATE_FORMAT(order_date, '%Y- %m')) AS t 
;
-- NB IF WE PARTITION OUR DATA BY THE DATE ( in this case order month ) our cummulative total will run for each year. after the year end, the cummulaton will start for the next year and so forth.

SELECT 
	order_month, 
	monthly_sales,
    SUM(monthly_sales) OVER (ORDER BY order_month ASC) AS monthly_running_total,
    ROUND(AVG(AVG_price) OVER (ORDER BY order_month ASC),'0') AS monthly_Moving_AVG_Price
FROM
(
SELECT 
	DATE_FORMAT(order_date, '%Y- %m') AS order_month,
    SUM(sales_amount) AS monthly_sales,
    AVG(price) AS AVG_price
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y- %m')
ORDER BY DATE_FORMAT(order_date, '%Y- %m')) AS t 
;
-- we can add the moving average to our query in order to see the trend of our price overtime. how the price is progressing with time.

/*----------------------------------------------------------------------------------------------------------------------
3) PERFORMANCE ANALYSIS :this is a process to compare our current value to a target value.
------------------------------------------------------------------------------------------------------------------------*/ 

-- TASK : ANALYZE THE YEARLY PERFORMANCE OF PRODUCTS BY COMPARING EACH PRODUCT'S SALES TO BOTH ITS AVERAGE SALES PERFORMANCE AND THE PREVIOUS YEAR'S SALES

WITH yearly_sales AS 
(
    SELECT
        DATE_FORMAT(s.order_date, '%Y') AS order_year,
        p.product_name,
        SUM(s.sales_amount) AS yearly_product_sale
    FROM gold_fact_sales AS s
    LEFT JOIN gold_dim_products AS p
        ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
    GROUP BY
        DATE_FORMAT(s.order_date, '%Y'),
        p.product_name
),

yearly_comparison AS
(
    SELECT
        order_year,
        product_name,
        yearly_product_sale,

        ROUND(
            AVG(yearly_product_sale) OVER (
                PARTITION BY product_name
            ), 0
        ) AS yearly_avg_product_sale,

        LAG(yearly_product_sale) OVER (
            PARTITION BY product_name
            ORDER BY order_year
        ) AS previous_year_sale
    FROM yearly_sales
)

SELECT
    order_year,
    product_name,
    yearly_product_sale,
    yearly_avg_product_sale,
    previous_year_sale,

    yearly_product_sale - yearly_avg_product_sale 
        AS sales_performance_compared_to_avg,

    CASE 
        WHEN yearly_product_sale > yearly_avg_product_sale THEN 'GOOD'
        WHEN yearly_product_sale < yearly_avg_product_sale THEN 'BAD'
        ELSE 'TARGET'
    END AS performance_status,

    yearly_product_sale - previous_year_sale 
        AS sales_performance_compared_to_previous_year,

    CASE 
        WHEN previous_year_sale IS NULL THEN 'NO PREVIOUS YEAR'
        WHEN yearly_product_sale > previous_year_sale THEN 'GOOD'
        WHEN yearly_product_sale < previous_year_sale THEN 'BAD'
        ELSE 'TARGET'
    END AS yearly_performance_status

FROM yearly_comparison
ORDER BY
    product_name,
    order_year; 
/*---------------------------------------------------------------------------------------------------
4) PART TO WHOLE ANALYSIS > this analysis is used to visualise the contribution of each aprt to the whole
----------------------------------------------------------------------------------------------------------*/ 

-- TASK : FIND OUT WHICH CATEGORIES CONTRIBUTE THE MOST TO THE OVERALL SALES 

WITH category_sale AS 
(
SELECT 
category,
SUM(sales_amount) AS total_sale
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_products AS p
ON s.product_key = p.product_key
GROUP BY category)

SELECT 
category,
total_sale,
SUM(total_sale) OVER () AS overall_sale,
CONCAT(ROUND((total_sale / SUM(total_sale) OVER ()) * 100,2), '%') AS total_sale_percentage
FROM category_sale
ORDER BY CONCAT(ROUND((total_sale / SUM(total_sale) OVER ()) * 100,2), '%') DESC;

/*-----------------------------------------------------------------------------------------------
5)DATA SEGMENTATION :
	PURPOSE: USED TO GROUP DATA BY SEGMENT (EXAMPLE : SEGMENT YOUR CUSTOMERS INTO 3 GROUP BASED ON THEIR SPENDING)
---------------------------------------------------------------------------------------------------*/

-- TASK1 : SEGMENT PRODUCTS INTO COST RANGES AND COUNT HOW MANY PRODUCTS FALL INTO EACH SEGMENT

WITH product_segment AS 

(SELECT 
	product_key,
	product_name,
	cost,
CASE 
	WHEN cost < 100 THEN 'Below 100'
    WHEN cost BETWEEN 100 AND 500 THEN '100-500'
    WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
ELSE 'Above 1000'
END AS cost_range
FROM gold_dim_products)

SELECT
cost_range,
COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY COUNT(product_key) DESC;

-- TASK2 : Group customers into three segments based on their spending behavior:
       -- VIP: customers with at least 12 months of history and spending more than $5000
       -- Regular: customers with at least 12 months of history and spending $5000 or less 
       -- New: customers with a lifespan less than 12 months
       -- And find the total number of customers by each group

WITH customer_3_segment AS 

(SELECT
	customer_key,
	SUM(sales_amount) AS total_sale,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date))AS customer_lifespan_month
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
	customer_key
) 
,
 customer_segmented AS
	(
	SELECT 
		customer_key,
		total_sale,
	CASE
		WHEN customer_lifespan_month >= 12 AND total_sale > 5000 THEN 'VIP'
		WHEN customer_lifespan_month >= 12 AND total_sale <= 5000 THEN 'REGULAR'
		ELSE 'NEW' 
	END AS customer_segment
	FROM customer_3_segment
)
SELECT
COUNT(customer_key) As total_customer,
customer_segment,
CASE 
	WHEN customer_segment = 'VIP'THEN '12 Month of history and spending $5000 or more ' 
    WHEN customer_segment = 'REGULAR'THEN '12 Month of history and spending $5000 or less'
    WHEN customer_segment = 'NEW'THEN 'less than 12 Month of history and spending any amount'
END AS customer_status 
FROM customer_segmented
GROUP BY customer_segment
ORDER BY total_customer ASC
;

/*==============================================================================
 REPORTING
 ===============================================================================
PURPOSE: organizing, summarizing, and presenting the results of the analysis in a format that stakeholders can easily consume and use for decision-making.
-------------------------------------------------------------------------------------------------*/

/*-- REPORT1: CUSTOMER REPORT
	-- PURPOSE : This report consolidates key customers metrics and behaviors 
    
Highlights:
	1. gather essential fields such as names, ages and transactions details.
    2. segment customers into categories (VIP, REGULAR, NEW) and age groups. 
    3. aggregate customer-level metrics:
		- total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
	4. calculate valuable KPIs:
		- recency ( months since last order)
        - average order value 
        - average monthly spend 
-----------------------------------------------------------------------------------------*/
/*
NOTE: Customer age analysis was excluded because the birthdate field contains insufficient and unreliable data. Only 19 of 18,458 customers have non-null birthdates, and most records contain invalid years (0001–0009), indicating a data quality issue.
*/

CREATE VIEW DWAnalytics_copy.report_customers AS 
WITH base_query AS 
(
SELECT
	s.order_number,
    s.product_key,
    s.order_date,
    s.sales_amount,
    s.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name,'  ', c.last_name) AS customer_name
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_customers AS c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL)
,

customer_aggregation AS 
(
SELECT 
	customer_key,
    customer_number,
	customer_name,
    COUNT(DISTINCT order_number) AS total_order,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key)AS total_product,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS customer_lifespan 
FROM base_query
GROUP BY 
	customer_key,
    customer_number,
	customer_name
)

SELECT
	customer_key,
    customer_number,
	customer_name,
    total_order,
    total_sales,
    total_quantity,
    total_product,
	customer_lifespan,
	CASE 
		WHEN customer_lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN customer_lifespan >= 12 AND total_sales <= 5000 THEN 'REGULAR'
		ELSE 'NEW' 
        END AS customer_segment,
        last_order_date,
        TIMESTAMPDIFF(MONTH, last_order_date, NOW()) AS recency,
        -- compute average order value (AOV)
        CASE 
			WHEN total_sales = 0 THEN 0
			ELSE ROUND(total_sales / total_order, 0) 
		END AS avg_order_value,
        -- compute average monthly spent
        CASE 
			WHEN customer_lifespan = 0 THEN total_sales
            ELSE ROUND(total_sales / customer_lifespan,2) 
		END AS avg_monthly_spent
FROM customer_aggregation
; 

SELECT *
FROM report_customers;

/*-------------------------------------------------------------------------------------
REPORT2 : PRODUCT REPORT 
	PURPOSE:  This report consolidates key products metrics and behaviors. 
    
HIGHLIGHTS: 
	1. Gather essential field such as product name, category, subcategory and cost. 
    2. Segment products by revenue to identify high-performers, mid-range or low performers. 
    3. Aggregates products-level metrics: 
		- total orders
        - total sales 
        - total quantity sold
        - total customers(unique)
        - lifespan (in month)
	4. Calculates valuable KPIs:
		-recency (months since last sale)
        -average order revenue(AOR)
        -average monthly revenue
=====================================================================================*/

-- required tables selection
SELECT*
FROM gold_fact_sales;

SELECT*
FROM gold_dim_products;
-- full query
WITH base_query AS 	
   ( 
    SELECT
		p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        SUM(s.sales_amount) As total_sales,
        COUNT(DISTINCT s.order_number) AS total_order,
        SUM(s.quantity) AS total_quantity_sold,
        COUNT(DISTINCT s.customer_key) As total_customer,
        MIN(s.order_date) AS first_order_date,
        MAX(s.order_date) AS last_order_date
	FROM gold_fact_sales AS s
	LEFT JOIN gold_dim_products AS p
	ON s.product_key = p.product_key
    GROUP BY 
		p.product_name,
        p.category,
        p.subcategory,
		p.cost
    )
    ,
    intermediate_query AS
    (
    SELECT
		product_name,
        category,
        subcategory,
        cost,
        total_sales,
        CASE 
			WHEN total_sales BETWEEN 500000 AND 1500000 THEN 'High performer'
            WHEN total_sales BETWEEN 200000 AND 499999 THEN 'Mid range'
            WHEN total_sales < 200000 THEN 'Low performer'
		END AS product_performance,
        total_order,
        total_quantity_sold,
        total_customer,
        TIMESTAMPDIFF(MONTH, first_order_date, last_order_date)+1 AS product_lifespan,
        CASE 
			WHEN TIMESTAMPDIFF(MONTH, first_order_date, last_order_date)+1 > 12 THEN 'Slow_seller'
            WHEN TIMESTAMPDIFF(MONTH, first_order_date, last_order_date)+1 BETWEEN 5 AND 12 THEN 'Regular_seller'
            ELSE 'High_seller'
		END AS product_status,
        TIMESTAMPDIFF(MONTH,last_order_date, CURDATE())AS product_recency 
		FROM base_query
   )
   SELECT
		product_name,
        category,
        subcategory,
        cost,
        total_sales,
        product_performance,
        total_order,
        total_quantity_sold,
        total_customer,
        product_lifespan,
        product_status,
        product_recency,
       ROUND(total_sales / total_order,0) AS avg_order_revenue,
       ROUND(total_sales / NULLIF(product_lifespan,0),0)AS avg_monthly_revenue
   FROM intermediate_query
   ORDER BY total_sales DESC
   ;
   
/* ===============================================
VIEW CREATION
====================================================*/

CREATE VIEW DWAnalytics_copy.report_products AS 
	WITH base_query AS 	
   ( 
    SELECT
		p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        SUM(s.sales_amount) As total_sales,
        COUNT(DISTINCT s.order_number) AS total_order,
        SUM(s.quantity) AS total_quantity_sold,
        COUNT(DISTINCT s.customer_key) As total_customer,
        MIN(s.order_date) AS first_order_date,
        MAX(s.order_date) AS last_order_date
	FROM gold_fact_sales AS s
	LEFT JOIN gold_dim_products AS p
	ON s.product_key = p.product_key
    GROUP BY 
		p.product_name,
        p.category,
        p.subcategory,
		p.cost
    )
    ,
    intermediate_query AS
    (
    SELECT
		product_name,
        category,
        subcategory,
        cost,
        total_sales,
        CASE 
			WHEN total_sales BETWEEN 500000 AND 1500000 THEN 'High performer'
            WHEN total_sales BETWEEN 200000 AND 499999 THEN 'Mid range'
            WHEN total_sales < 200000 THEN 'Low performer'
		END AS product_performance,
        total_order,
        total_quantity_sold,
        total_customer,
        TIMESTAMPDIFF(MONTH, first_order_date, last_order_date)+1 AS product_lifespan,
        CASE 
			WHEN TIMESTAMPDIFF(MONTH, first_order_date, last_order_date)+1 > 12 THEN 'Slow_seller'
            WHEN TIMESTAMPDIFF(MONTH, first_order_date, last_order_date)+1 BETWEEN 5 AND 12 THEN 'Regular_seller'
            ELSE 'High_seller'
		END AS product_status,
        TIMESTAMPDIFF(MONTH,last_order_date, CURDATE())AS product_recency 
		FROM base_query
   )
   SELECT
		product_name,
        category,
        subcategory,
        cost,
        total_sales,
        product_performance,
        total_order,
        total_quantity_sold,
        total_customer,
        product_lifespan,
        product_status,
        product_recency,
       ROUND(total_sales / total_order,0) AS avg_order_revenue,
       ROUND(total_sales / NULLIF(product_lifespan,0),0)AS avg_monthly_revenue
   FROM intermediate_query
   ORDER BY total_sales DESC
   ;
   
   SELECT*
   FROM report_products;
   
   
