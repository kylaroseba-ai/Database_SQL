SELECT
    il.log_date,
    il.shift,
    id.opening,
    id.additions,
    id.closing,
    id.daily_usage,
    id.waste,
    ROUND(id.daily_usage / NULLIF(id.opening + id.additions, 0) * 100, 1)
                                AS usage_rate_pct
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id = id.log_id
JOIN item               i  ON i.item_id = id.item_id
WHERE i.item_name = 'Pork Belly'
ORDER BY il.log_date, il.shift;
