SELECT
    TO_CHAR("order_date", 'Month YYYY') AS year_month,
    COUNT("order_id") AS total_orders,
    ROUND(SUM("freight")) AS total_freight
FROM
    "orders"
WHERE
    "order_date" BETWEEN '1997-01-01' AND '1998-12-31'
GROUP BY
    year_month
HAVING
    COUNT("order_id") > 35
ORDER BY
    total_freight DESC;