/*-----------------------------------------------------------------------------------------------
DATA SEGMENTATION
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