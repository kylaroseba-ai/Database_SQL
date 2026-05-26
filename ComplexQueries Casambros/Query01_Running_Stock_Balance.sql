-- ============================================================
-- Query 1: Running Stock Balance Per Item Over Time
-- Technique: SUM() OVER, LAG() window functions
-- ============================================================

SELECT
    il.log_date,
    il.shift,
    i.item_name,
    c.cat_name                          AS category,
    u.unit_abbr                         AS unit,
    id.opening,
    id.additions,
    id.closing,
    id.daily_usage,
    id.waste,
    SUM(id.daily_usage)
        OVER (
            PARTITION BY id.item_id
            ORDER BY il.log_date, il.shift
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )                               AS cumulative_usage,
    LAG(id.closing)
        OVER (
            PARTITION BY id.item_id
            ORDER BY il.log_date, il.shift
        )                               AS prev_closing,
    id.opening - LAG(id.closing)
        OVER (
            PARTITION BY id.item_id
            ORDER BY il.log_date, il.shift
        )                               AS stock_discrepancy
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id   = id.log_id
JOIN item               i  ON i.item_id   = id.item_id
JOIN category           c  ON c.cat_id    = i.cat_id
JOIN unit               u  ON u.unit_id   = i.unit_id
WHERE i.item_name = 'Pork Belly'
ORDER BY il.log_date, il.shift;
