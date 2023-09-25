SELECT
    product_name AS "Product Name",
    unit_price AS "Unit Price"
FROM
    products
WHERE
    unit_price >= 20
    AND unit_price <= 50
    AND discontinued = 0
ORDER BY
    unit_price DESC;