/*===============================
PRODUCT REPORT 
================================
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