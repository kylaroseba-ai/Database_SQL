SELECT
    c.cat_name                  AS category,
    COUNT(id.item_id)           AS items_tracked,
    SUM(id.daily_usage)         AS total_usage,
    u.unit_abbr                 AS primary_unit
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id = id.log_id
JOIN item               i  ON i.item_id = id.item_id
JOIN category           c  ON c.cat_id  = i.cat_id
JOIN unit               u  ON u.unit_id = i.unit_id
WHERE il.log_date = '2025-04-18'
  AND il.shift    = 'Opening'
GROUP BY c.cat_name, u.unit_abbr
ORDER BY total_usage DESC;
