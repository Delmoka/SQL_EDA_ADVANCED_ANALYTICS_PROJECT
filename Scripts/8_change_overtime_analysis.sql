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
