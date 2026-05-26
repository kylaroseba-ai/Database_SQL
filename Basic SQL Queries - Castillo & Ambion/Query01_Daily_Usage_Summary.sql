SELECT
    c.cat_name                  AS category,
    i.item_name,
    u.unit_abbr                 AS unit,
    id.opening,
    id.additions,
    id.closing,
    id.daily_usage,
    id.waste
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id  = id.log_id
JOIN item               i  ON i.item_id  = id.item_id
JOIN category           c  ON c.cat_id   = i.cat_id
JOIN unit               u  ON u.unit_id  = i.unit_id
WHERE il.log_date = '2025-04-18'
  AND il.shift    = 'Opening'
ORDER BY c.cat_name, id.daily_usage DESC;
