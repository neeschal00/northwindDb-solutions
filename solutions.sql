-- Solutions to the Business questions:
-- Question 1
-- For their annual review of the company pricing strategy, the Product Team wants to look at the products that are currently being offered for a specific price range ($20 to $50). In order to help them they asked you to provide them with a list of products with the following information:
-- 1.	their name
-- 2.	their unit price
-- Filtered on the following conditions:
-- 1.	their unit price is between 20 and 50 (greater or equal to 20 but less or equal than 50)
-- 2.	they are not discontinued
-- Finally order the results by unit price in a descending order (highest first).
-- select * from products;
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


-- Question 2
-- The Logistics Team wants to do a retrospection of their performances for the year 1998, in order to identify for which countries they didn’t perform well. They asked you to provide them a list of countries with the following information:
-- 1.	their average days between the order date and the shipping date (formatted to have only 2 decimals)
-- 2.	their total number of unique orders (based on the order id) 
-- Filtered on the following conditions:
-- 1.	the year of order date is 1998
-- 2.	their average days between the order date and the shipping date is greater or equal 5 days
-- 3.	their total number of orders is greater than 10 orders
-- Finally order the results by country name in an ascending order (following alphabetical order).
-- select * from orders;

SELECT
	"ship_country" AS "Country",
    ROUND(AVG("shipped_date" - "order_date"), 2) AS "Average Days",
	COUNT(DISTINCT "order_id") AS "Total Unique Orders"
FROM
    orders
WHERE
  EXTRACT(YEAR FROM order_date) = 1998
GROUP BY
    "ship_country"
HAVING 
	ROUND(AVG("shipped_date" - "order_date"), 2) >= 5
	AND
	COUNT(DISTINCT "order_id") > 10
ORDER BY
	"Country" ASC;

-- Question 3
-- The HR Team wants to know for each employee what was their age on the date they joined the company and who they currently report to. Provide them with a list of every employees with the following information:
-- 1.	their full name (first name and last name combined in a single field)
-- 2.	their job title
-- 3.	their age at the time they were hired
-- 4.	their manager full name (first name and last name combined in a single field)
-- 5.	their manager job title
-- Finally order the results by employee age and employee full name in an ascending order (lowest first).

-- select * from esmployees;

SELECT
    CONCAT(e."first_name", ' ',e."last_name") AS "Employee Full Name",
    e."title" AS "Job Title",
    EXTRACT(YEAR FROM AGE(e."hire_date", e."birth_date")) AS "Age at Hire",
    CONCAT(mgr."first_name", ' ', mgr."last_name") AS "Manager Full Name",
    mgr."title" AS "Manager Job Title"
FROM
    "employees" e
LEFT JOIN
    "employees" mgr ON e."reports_to" = mgr."employee_id"
ORDER BY
    "Age at Hire" ASC,
    "Employee Full Name" ASC;

-- Question 4
-- The Logistics Team wants to do a retrospection of their global performances over 1997-1998, in order to identify for which month they perform well. They asked you to provide them a list with:
-- 1.	their year/month as single field in a date format (e.g. “1990-01-01” for January 1990)
-- 2.	their total number of orders
-- 3.	their total freight (formatted to have no decimals)
-- Filtered on the following conditions:
-- 1.	the order date is between 1997 and 1998
-- 2.	their total number of orders is greater than 35 orders
-- Finally order the results by total freight (descending order).
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


-- Question 5
-- The Pricing Team wants to know which products had an unit price increase and the percentage increase was not between 20% and 30%. In order to help them they asked you to provide them a list of products with:
-- 1.	their product name
-- 2.	their current unit price (formatted to have only 2 decimals)
-- 3.	their initial unit price (formatted to have only 2 decimals)
-- 4.	their percentage increase with the result formatted to an integer (e.g 50 for 50%)  using the following calculation: 
-- (Current Unit Price - Initial Unit Price) ÷ Initial Unit Price * 100
-- Filtered on the following conditions:
-- 1.	their percentage increase is not between 20% and 30%  (lower than 20 or greater than 30)
-- Finally order the results by percentage increase (ascending order).
-- select * from products;
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
	
	
-- Question 6
-- The Pricing Team wants to know how each category performs according to their price range. In order to help them they asked you to provide them a list of categories with:
-- 1.	their category name
-- 2.	their price range as: 
-- 1.	“1. Below $20”
-- 2.	“2. $20 - $50”
-- 3.	“3. Over $50”
-- 3.	their total amount (formatted to be integer) taking into account the offered discount (i.e. subtracting the discounted amount)
-- 4.	their volume of orders (number of orders in which the category was present)
-- Finally order the results by category name then price range (both ascending order).
select * from categories;
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

-- Question 7
-- The Logistics Team wants to know what is the current state of our regional suppliers' stocks for each category of product. In order to help them they asked you to provide them a list of categories with:
-- 1.	their supplier region” as: 
-- 1.	“America”
-- 2.	“Europe”
-- 3.	“Asia-Pacific”
-- 2.	their category name
-- 3.	their total units in stock
-- 4.	their total units on order
-- 5.	their total reorder level
-- Finally order the results by category name, then supplier region and reorder level (each in ascending order).

-- select distinct(country) from suppliers;
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

-- Question 8
-- The Pricing Team wants to know for each currently offered product how their unit price compares against their categories average and median unit price. In order to help them they asked you to provide them a list of products with:
-- 1.	their category name
-- 2.	their product name
-- 3.	their unit price
-- 4.	their category average unit price (formatted to have only 2 decimals)
-- 5.	their category median unit price (formatted to have only 2 decimals)
-- 6.	their position against the category average unit price as:
-- 1.	“Below Average”
-- 2.	“Equal Average”
-- 3.	“Over Average”
-- 7.	their position against the category median unit price as:
-- 1.	“Below Median”
-- 2.	“Equal Median”
-- 3.	“Over Median”
-- Filtered on the following conditions:
-- 1.	They are not discontinued 
-- Finally order the results by category name then product name (both ascending).
select * from categories;
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


-- Question 9
-- The Sales Team wants to build a list of KPIs to measure employees' performances. In order to help them they asked you to provide them a list of employees with:
-- 1.	their full name (first name and last name combined in a single field)
-- 2.	their job title
-- 3.	their total sales amount excluding discount (formatted to have only 2 decimals)
-- 4.	their total number of unique orders
-- 5.	their total number of orders
-- 6.	their average product amount excluding discount (formatted to have only 2 decimals). This corresponds to the average amount of product sold (without taking into account any discount applied to it).
-- 7.	their average order amount excluding discount (formatted to have only 2 decimals). This corresponds to the ratio between the total amount of product sold (without taking into account any discount applied to it) against to the total number of unique orders.
-- 8.	their total discount amount (formatted to have only 2 decimals)
-- 9.	their total sales amount including discount (formatted to have only 2 decimals)
-- 10.	Their total discount percentage (formatted to have only 2 decimals)
-- Finally order the results by total sales amount including discount (descending).
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

-- Question 10
-- The Sales Team wants to build another list of KPIs to measure employees' performances across each category. In order to help them they asked you to provide them a list of categories and employees with:
-- 1.	their categories name
-- 2.	their full name (first name and last name combined in a single field)
-- 3.	their total sales amount including discount (formatted to have only 2 decimals)
-- 4.	their percentage of total sales amount including discount against his/her total sales amount across all categories (formatted to have only 5 decimals and maximum value up to 1)
-- 5.	their percentage of total sales amount including discount against the total sales amount across all employees (formatted to have only 5 decimals and maximum value up to 1)
-- Finally order the results by category name (ascending) then total sales amount (descending).


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


