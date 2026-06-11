 CUMULATIVE ANALYSIS ( this analysis helps us see the evolution of the business through time . like overall sales from start of the year to the end of the year. 
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