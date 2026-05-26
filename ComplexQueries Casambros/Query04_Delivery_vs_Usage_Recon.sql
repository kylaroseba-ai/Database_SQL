-- ============================================================
-- Query 4: Delivery vs. Usage Reconciliation
-- Technique: Parallel CTEs, FULL OUTER JOIN, COALESCE
-- ============================================================

WITH
delivery_totals AS (
    SELECT
        dd.item_id,
        SUM(dd.qty_received)    AS total_delivered
    FROM delivery_detail    dd
    JOIN delivery           d  ON d.delivery_id = dd.delivery_id
    WHERE d.delivery_date BETWEEN '2026-05-13' AND '2026-05-19'
    GROUP BY dd.item_id
),
usage_totals AS (
    SELECT
        id.item_id,
        SUM(id.daily_usage)     AS total_consumed
    FROM inventory_detail   id
    JOIN inventory_log      il ON il.log_id = id.log_id
    WHERE il.log_date BETWEEN '2026-05-13' AND '2026-05-19'
    GROUP BY id.item_id
)
SELECT
    c.cat_name                              AS category,
    i.item_name,
    u.unit_abbr                             AS unit,
    COALESCE(dt.total_delivered, 0)         AS total_delivered,
    COALESCE(ut.total_consumed, 0)          AS total_consumed,
    COALESCE(dt.total_delivered, 0)
        - COALESCE(ut.total_consumed, 0)    AS net_gap,
    CASE
        WHEN COALESCE(ut.total_consumed, 0) = 0 THEN 'NO USAGE DATA'
        WHEN (dt.total_delivered
              - COALESCE(ut.total_consumed, 0))
             / NULLIF(ut.total_consumed, 0) > 0.5 THEN 'OVER-DELIVERED'
        WHEN dt.total_delivered IS NULL       THEN 'NO DELIVERY'
        ELSE                                       'BALANCED'
    END                                     AS reconciliation_status
FROM delivery_totals    dt
FULL OUTER JOIN usage_totals ut ON ut.item_id   = dt.item_id
JOIN item               i  ON i.item_id = COALESCE(dt.item_id, ut.item_id)
JOIN category           c  ON c.cat_id  = i.cat_id
JOIN unit               u  ON u.unit_id = i.unit_id
ORDER BY ABS(COALESCE(dt.total_delivered, 0)
             - COALESCE(ut.total_consumed, 0)) DESC;
