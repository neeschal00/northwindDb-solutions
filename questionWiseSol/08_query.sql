WITH CategoryStats AS (
    SELECT
        c."category_id",
        c."category_name",
        AVG(p."unit_price") AS "Category Avg Unit Price",
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY p."unit_price") AS "Category Median Unit Price"
    FROM
        "categories" c
    INNER JOIN
        "products" p ON c."category_id" = p."category_id"
    GROUP BY
        c."category_id",
        c."category_name"
)
SELECT
    cs."category_name" AS "Category Name",
    p."product_name" AS "Product Name",
    p."unit_price" AS "Unit Price",
    ROUND(cs."Category Avg Unit Price"::numeric, 2) AS "Category Avg Unit Price",
    ROUND(cs."Category Median Unit Price"::numeric, 2) AS "Category Median Unit Price",
    CASE
        WHEN p."unit_price" < cs."Category Avg Unit Price" THEN 'Below Average'
        WHEN p."unit_price" = cs."Category Avg Unit Price" THEN 'Equal Average'
        ELSE 'Over Average'
    END AS "Position Against Category Avg",
    CASE
        WHEN p."unit_price" < cs."Category Median Unit Price" THEN 'Below Median'
        WHEN p."unit_price" = cs."Category Median Unit Price" THEN 'Equal Median'
        ELSE 'Over Median'
    END AS "Position Against Category Median"
FROM
    "products" p
INNER JOIN
    CategoryStats cs ON p."category_id" = cs."category_id"
WHERE
    p."discontinued" = 0
ORDER BY
    "Category Name" ASC,
    "Product Name" ASC;