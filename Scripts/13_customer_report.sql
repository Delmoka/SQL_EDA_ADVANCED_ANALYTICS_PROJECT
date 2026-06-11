/*===========================
CUSTOMER REPORT
==============================
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
