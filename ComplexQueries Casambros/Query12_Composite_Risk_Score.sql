-- ============================================================
-- Query 12: Top Items by Composite Risk Score
-- Technique: Normalized multi-CTE, DENSE_RANK(), NULLIF guard
-- ============================================================

WITH
waste_scores AS (
    SELECT
        id.item_id,
        CASE WHEN SUM(id.daily_usage) = 0 THEN 0
             ELSE SUM(id.waste) / SUM(id.daily_usage)
        END                                     AS waste_rate
    FROM inventory_detail id
    JOIN inventory_log    il ON il.log_id = id.log_id
    WHERE il.log_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY id.item_id
),
low_stock_scores AS (
    SELECT
        id.item_id,
        COUNT(*) FILTER (WHERE id.closing < 500)    AS low_stock_events
    FROM inventory_detail id
    JOIN inventory_log    il ON il.log_id = id.log_id
    WHERE il.log_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY id.item_id
),
audit_scores AS (
    SELECT
        id.item_id,
        COUNT(ia.audit_id)                          AS correction_count
    FROM inventory_detail   id
    LEFT JOIN inventory_audit ia ON ia.detail_id = id.detail_id
    GROUP BY id.item_id
),
combined AS (
    SELECT
        ws.item_id,
        COALESCE(ws.waste_rate, 0)              AS waste_rate,
        COALESCE(ls.low_stock_events, 0)        AS low_stock_events,
        COALESCE(au.correction_count, 0)        AS correction_count,
        ROUND(COALESCE(ws.waste_rate, 0)
            / NULLIF(MAX(ws.waste_rate) OVER (), 0), 4)
                                                AS norm_waste,
        ROUND(COALESCE(ls.low_stock_events, 0)
            / NULLIF(MAX(ls.low_stock_events) OVER (), 0)::NUMERIC, 4)
                                                AS norm_low_stock,
        ROUND(COALESCE(au.correction_count, 0)
            / NULLIF(MAX(au.correction_count) OVER (), 0)::NUMERIC, 4)
                                                AS norm_corrections
    FROM waste_scores       ws
    LEFT JOIN low_stock_scores ls ON ls.item_id = ws.item_id
    LEFT JOIN audit_scores     au ON au.item_id = ws.item_id
)
SELECT
    c.cat_name                              AS category,
    i.item_name,
    ROUND(norm_waste, 3)                    AS norm_waste_score,
    ROUND(norm_low_stock, 3)               AS norm_low_stock_score,
    ROUND(norm_corrections, 3)             AS norm_audit_score,
    ROUND(norm_waste + norm_low_stock + norm_corrections, 3) AS composite_risk_score,
    DENSE_RANK() OVER (
        ORDER BY norm_waste + norm_low_stock + norm_corrections DESC
    )                                       AS risk_rank
FROM combined           co
JOIN item               i  ON i.item_id = co.item_id
JOIN category           c  ON c.cat_id  = i.cat_id
ORDER BY risk_rank
LIMIT 10;
