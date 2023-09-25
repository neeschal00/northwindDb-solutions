SELECT
    c."category_name" AS "Category Name",
    CASE
        WHEN p."unit_price" < 20 THEN '1. Below $20'
        WHEN p."unit_price" BETWEEN 20 AND 50 THEN '2. $20 - $50'
        ELSE '3. Over $50'
    END AS "Price Range",
    SUM(ROUND((od."unit_price" * od."quantity" * (1 - od."discount"))::numeric, 0)) AS "Total Amount",
    COUNT(DISTINCT o."order_id") AS "Volume of Orders"
FROM
    "categories" c
LEFT JOIN
    "products" p ON c."category_id" = p."category_id"
LEFT JOIN
    "order_details" od ON p."product_id" = od."product_id"
LEFT JOIN
    "orders" o ON od."order_id" = o."order_id"
GROUP BY
    c."category_name",
    "Price Range"
ORDER BY
    c."category_name" ASC,
    "Price Range" ASC;