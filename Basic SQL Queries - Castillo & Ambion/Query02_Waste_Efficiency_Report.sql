SELECT
    i.item_name,
    c.cat_name          AS category,
    u.unit_abbr         AS unit,
    SUM(id.waste)       AS total_waste
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id  = id.log_id
JOIN item               i  ON i.item_id  = id.item_id
JOIN category           c  ON c.cat_id   = i.cat_id
JOIN unit               u  ON u.unit_id  = i.unit_id
WHERE il.log_date BETWEEN '2025-04-16' AND '2025-04-18'
  AND id.waste > 0
GROUP BY i.item_name, c.cat_name, u.unit_abbr
ORDER BY total_waste DESC;
