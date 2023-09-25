WITH EmployeeCategoryPerformance AS (
    SELECT
        c."category_name",
        CONCAT(e."first_name", ' ', e."last_name") AS "Full Name",
        SUM(od."unit_price" * od."quantity" * (1 - od."discount")) AS "Total Sales Amount Including Discount"
    FROM
        "categories" c
    INNER JOIN
        "products" p ON c."category_id" = p."category_id"
    INNER JOIN
        "order_details" od ON p."product_id" = od."product_id"
    INNER JOIN
        "orders" o ON od."order_id" = o."order_id"
    INNER JOIN
        "employees" e ON o."employee_id" = e."employee_id"
    GROUP BY
        c."category_name",
        e."employee_id"
),
EmployeeTotalSales AS (
    SELECT
        CONCAT(e."first_name", ' ', e."last_name") AS "Full Name",
        SUM(od."unit_price" * od."quantity" * (1 - od."discount")) AS "Total Sales Amount Including Discount"
    FROM
        "order_details" od
    INNER JOIN
        "orders" o ON od."order_id" = o."order_id"
    INNER JOIN
        "employees" e ON o."employee_id" = e."employee_id"
    GROUP BY
        e."employee_id"
)
SELECT
    ecp."category_name" AS "Category Name",
    ecp."Full Name" AS "Full Name",
    ROUND(ecp."Total Sales Amount Including Discount"::numeric, 2) AS "Total Sales Amount Including Discount",
    ROUND((ecp."Total Sales Amount Including Discount" / et."Total Sales Amount Including Discount")::numeric, 5) AS "Percentage of Total Sales in Category",
    ROUND((ecp."Total Sales Amount Including Discount" / t."Total Sales Amount Including Discount")::numeric, 5) AS "Percentage of Total Sales Overall"
FROM
    EmployeeCategoryPerformance ecp
INNER JOIN
    EmployeeTotalSales et ON ecp."Full Name" = et."Full Name"
CROSS JOIN (
    SELECT SUM("Total Sales Amount Including Discount") AS "Total Sales Amount Including Discount"
    FROM EmployeeTotalSales
) AS t
ORDER BY
    "Category Name" ASC,
    "Total Sales Amount Including Discount" DESC;