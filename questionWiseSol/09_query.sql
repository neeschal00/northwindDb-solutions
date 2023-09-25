WITH EmployeePerformance AS (
    SELECT
        e."employee_id",
        CONCAT(e."first_name", ' ', e."last_name") AS "Full Name",
        e."title" AS "Job Title",
        SUM(od."unit_price" * od."quantity" * (1 - od."discount")) AS "Total Sales Amount Excluding Discount",
        COUNT(DISTINCT o."order_id") AS "Total Unique Orders",
        COUNT(o."order_id") AS "Total Orders",
        ROUND(AVG(od."unit_price" * od."quantity" * (1 - od."discount"))::numeric, 2) AS "Average Product Amount Excluding Discount",
        ROUND((SUM(od."unit_price" * od."quantity" * (1 - od."discount")) / COUNT(DISTINCT o."order_id"))::numeric, 2) AS "Average Order Amount Excluding Discount",
        SUM(od."unit_price" * od."quantity" * od."discount") AS "Total Discount Amount",
        SUM(od."unit_price" * od."quantity") AS "Total Sales Amount Including Discount",
        ROUND(((SUM(od."unit_price" * od."quantity" * od."discount") / SUM(od."unit_price" * od."quantity")) * 100)::numeric, 2) AS "Total Discount Percentage"
    FROM
        "employees" e
    LEFT JOIN
        "orders" o ON e."employee_id" = o."employee_id"
    LEFT JOIN
        "order_details" od ON o."order_id" = od."order_id"
    GROUP BY
        e."employee_id"
)
SELECT
    "Full Name",
    "Job Title",
    "Total Sales Amount Excluding Discount",
    "Total Unique Orders",
    "Total Orders",
    "Average Product Amount Excluding Discount",
    "Average Order Amount Excluding Discount",
    "Total Discount Amount",
    "Total Sales Amount Including Discount",
    "Total Discount Percentage"
FROM
    EmployeePerformance
ORDER BY
    "Total Sales Amount Including Discount" DESC;