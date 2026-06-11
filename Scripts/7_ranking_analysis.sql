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