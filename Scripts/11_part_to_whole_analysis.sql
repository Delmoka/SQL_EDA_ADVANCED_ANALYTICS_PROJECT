/*---------------------------------------------------------------------------------------------------
 PART TO WHOLE ANALYSIS > this analysis is used to visualise the contribution of each aprt to the whole
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