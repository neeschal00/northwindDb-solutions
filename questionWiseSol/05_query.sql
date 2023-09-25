SELECT
    "product_name" AS "Product Name",
    ROUND("unit_price"::numeric, 2) AS "Current Unit Price",
    ROUND("initial_price"::numeric, 2) AS "Initial Unit Price",
    ROUND(((("unit_price"::numeric - "initial_price"::numeric) / "initial_price"::numeric) * 100)::integer, 0) AS "Percentage Increase"
FROM (
    SELECT
        p."product_name",
        p."unit_price"::numeric,
        p."unit_price"::numeric AS "initial_price"
    FROM
        "products" p
    UNION ALL
    SELECT
        p."product_name",
        p."unit_price"::numeric,
        o."unit_price"::numeric AS "initial_price"
    FROM
        "products" p
    JOIN
        "order_details" o ON p."product_id" = o."product_id"
    WHERE
        o."order_id" = (SELECT MIN("order_id") FROM "order_details" WHERE "product_id" = p."product_id")
) AS "initial_prices"
WHERE
    ROUND(((("unit_price"::numeric - "initial_price"::numeric) / "initial_price"::numeric) * 100)::integer, 0) NOT BETWEEN 20 AND 30
ORDER BY
    "Percentage Increase" ASC;