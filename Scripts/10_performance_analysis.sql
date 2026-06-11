/*----------------------------------------------------------------------------------------------------------------------
 PERFORMANCE ANALYSIS :this is a process to compare our current value to a target value.
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