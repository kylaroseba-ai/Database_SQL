SELECT
    il.log_date,
    il.shift,
    e.emp_name          AS logged_by,
    e.role,
    COUNT(id.detail_id) AS items_recorded
FROM inventory_log      il
JOIN employee           e  ON e.emp_id = il.emp_id
LEFT JOIN inventory_detail id ON id.log_id = il.log_id
GROUP BY il.log_date, il.shift, e.emp_name, e.role, il.log_id
ORDER BY il.log_date, il.shift;
