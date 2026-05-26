SELECT
    i.item_name,
    id.closing                  AS closing_stock_g,
    ROUND(id.closing / 1000, 2) AS closing_stock_kg
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id = id.log_id
JOIN item               i  ON i.item_id = id.item_id
JOIN category           c  ON c.cat_id  = i.cat_id
WHERE il.log_date = '2025-04-18'
  AND il.shift    = 'Opening'
  AND c.cat_name  = 'Frozen Meat'
ORDER BY id.closing DESC;
