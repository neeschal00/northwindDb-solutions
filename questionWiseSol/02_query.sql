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