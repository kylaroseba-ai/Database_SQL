SELECT
    i.item_name                         AS side_dish,
    id.additions                        AS produced_today,
    id.daily_usage,
    id.closing                          AS leftover,
    CASE
        WHEN id.additions = 0 THEN NULL
        ELSE ROUND(id.daily_usage / id.additions * 100, 1)
    END                                 AS usage_vs_production_pct,
    CASE
        WHEN id.closing > (id.daily_usage * 0.5)
            THEN 'OVER-PRODUCED'
        WHEN id.closing = 0
            THEN 'FULLY CONSUMED'
        ELSE 'NORMAL'
    END                                 AS production_status
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id = id.log_id
JOIN item               i  ON i.item_id = id.item_id
JOIN category           c  ON c.cat_id  = i.cat_id
WHERE il.log_date   = '2025-04-18'
  AND il.shift      = 'Opening'
  AND c.cat_name    = 'Side Dish'
ORDER BY leftover DESC;
