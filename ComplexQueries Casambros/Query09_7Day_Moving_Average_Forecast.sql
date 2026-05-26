-- ============================================================
-- Query 9: 7-Day Moving Average Usage Forecast
-- Technique: AVG() OVER ROWS BETWEEN PRECEDING AND CURRENT ROW
-- ============================================================

SELECT
    i.item_name,
    c.cat_name              AS category,
    u.unit_abbr             AS unit,
    il.log_date,
    il.shift,
    id.daily_usage,
    ROUND(
        AVG(id.daily_usage) OVER (
            PARTITION BY id.item_id
            ORDER BY il.log_date, il.shift
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2)               AS moving_avg_7sessions,
    ROUND(
        id.daily_usage - AVG(id.daily_usage) OVER (
            PARTITION BY id.item_id
            ORDER BY il.log_date, il.shift
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2)               AS deviation_from_avg,
    CASE
        WHEN id.daily_usage > AVG(id.daily_usage) OVER (
            PARTITION BY id.item_id
            ORDER BY il.log_date, il.shift
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) * 1.30 THEN 'ABOVE TREND'
        WHEN id.daily_usage < AVG(id.daily_usage) OVER (
            PARTITION BY id.item_id
            ORDER BY il.log_date, il.shift
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) * 0.70 THEN 'BELOW TREND'
        ELSE 'ON TREND'
    END                     AS trend_position
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id  = id.log_id
JOIN item               i  ON i.item_id  = id.item_id
JOIN category           c  ON c.cat_id   = i.cat_id
JOIN unit               u  ON u.unit_id  = i.unit_id
WHERE i.item_name IN ('Pork Belly', 'Moksal', 'Daepae')
ORDER BY i.item_name, il.log_date, il.shift;
