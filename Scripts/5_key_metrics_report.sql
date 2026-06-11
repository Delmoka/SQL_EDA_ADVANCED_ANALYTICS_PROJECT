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
