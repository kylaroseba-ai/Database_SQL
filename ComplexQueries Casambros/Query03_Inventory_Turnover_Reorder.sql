-- ============================================================
-- Query 3: Inventory Turnover Rate and Reorder Priority
-- Technique: CTE, AVG, CASE WHEN urgency tiers
-- ============================================================

WITH recent_usage AS (
    SELECT
        id.item_id,
        AVG(id.daily_usage)             AS avg_daily_usage,
        MAX(il.log_date)                AS last_log_date,
        MAX(id.closing)
            FILTER (WHERE il.log_date = (
                SELECT MAX(il2.log_date)
                FROM inventory_log il2
            ))                          AS latest_closing
    FROM inventory_detail   id
    JOIN inventory_log      il ON il.log_id = id.log_id
    WHERE il.log_date >= CURRENT_DATE - INTERVAL '14 days'
    GROUP BY id.item_id
)
SELECT
    c.cat_name                              AS category,
    i.item_name,
    u.unit_abbr                             AS unit,
    ROUND(ru.avg_daily_usage, 2)            AS avg_daily_usage,
    ROUND(ru.latest_closing, 2)             AS current_stock,
    CASE
        WHEN ru.avg_daily_usage = 0 THEN NULL
        ELSE ROUND(ru.latest_closing / ru.avg_daily_usage, 1)
    END                                     AS days_remaining,
    CASE
        WHEN ru.avg_daily_usage = 0                                         THEN 'NO CONSUMPTION'
        WHEN ru.latest_closing / NULLIF(ru.avg_daily_usage, 0) <= 1        THEN 'REORDER NOW'
        WHEN ru.latest_closing / NULLIF(ru.avg_daily_usage, 0) <= 2        THEN 'REORDER SOON'
        WHEN ru.latest_closing / NULLIF(ru.avg_daily_usage, 0) <= 5        THEN 'MONITOR'
        ELSE                                                                     'ADEQUATE'
    END                                     AS reorder_status
FROM recent_usage       ru
JOIN item               i  ON i.item_id = ru.item_id
JOIN category           c  ON c.cat_id  = i.cat_id
JOIN unit               u  ON u.unit_id = i.unit_id
ORDER BY
    CASE WHEN ru.avg_daily_usage > 0
         THEN ru.latest_closing / ru.avg_daily_usage
         ELSE 9999 END ASC;
