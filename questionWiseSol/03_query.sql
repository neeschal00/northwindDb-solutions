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