SELECT
    c.cat_name,
    i.item_name,
    u.unit_abbr         AS unit,
    id.opening,
    id.closing,
    id.daily_usage,
    id.closing          AS remaining_stock
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id = id.log_id
JOIN item               i  ON i.item_id = id.item_id
JOIN category           c  ON c.cat_id  = i.cat_id
JOIN unit               u  ON u.unit_id = i.unit_id
WHERE il.log_date   = '2025-04-18'
  AND il.shift      = 'Opening'
  AND id.additions  = 0
  AND id.daily_usage > 0
ORDER BY id.closing ASC;
