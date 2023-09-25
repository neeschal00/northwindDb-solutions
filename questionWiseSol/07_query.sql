SELECT
    CASE
        WHEN s."country" IN ('Spain', 'Italy') THEN 'Europe'
        WHEN s."country" IN ('Norway', 'Sweden') THEN 'Europe'
        WHEN s."country" IN ('France', 'USA') THEN 'America'
        WHEN s."country" IN ('Netherlands', 'Brazil') THEN 'America'
        WHEN s."country" IN ('Australia', 'UK') THEN 'Asia-Pacific'
        WHEN s."country" IN ('Germany') THEN 'Europe'
        ELSE 'Unknown'
    END AS "Supplier Region",
    c."category_name" AS "Category Name",
    SUM(p."unit_in_stock") AS "Total Units in Stock",
    SUM(p."unit_on_order") AS "Total Units on Order",
    SUM(p."reorder_level") AS "Total Reorder Level"
FROM
    "suppliers" s
INNER JOIN
    "products" p ON s."supplier_id" = p."supplier_id"
INNER JOIN
    "categories" c ON p."category_id" = c."category_id"
WHERE
    s."country" IN ('Spain', 'Italy', 'Norway', 'Sweden', 'France', 'USA', 'Netherlands', 'Brazil', 'Australia', 'UK', 'Germany')
GROUP BY
    "Supplier Region",
    c."category_name"
ORDER BY
    c."category_name" ASC,
    "Supplier Region" ASC,
    "Total Reorder Level" ASC;