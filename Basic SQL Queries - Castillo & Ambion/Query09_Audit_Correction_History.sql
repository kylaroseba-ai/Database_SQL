SELECT
    ia.changed_at,
    e.emp_name          AS corrected_by,
    i.item_name,
    il.log_date         AS session_date,
    il.shift,
    ia.field_changed,
    ia.old_val,
    ia.new_val,
    (ia.new_val - ia.old_val) AS difference,
    ia.reason
FROM inventory_audit    ia
JOIN inventory_detail   id ON id.detail_id = ia.detail_id
JOIN inventory_log      il ON il.log_id    = id.log_id
JOIN item               i  ON i.item_id    = id.item_id
JOIN employee           e  ON e.emp_id     = ia.emp_id
ORDER BY ia.changed_at DESC;
