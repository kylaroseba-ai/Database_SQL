-- ============================================================
-- Query 5: Supplier Reliability Dashboard
-- Technique: Multi-table JOIN chain, parallel CTEs
-- ============================================================

WITH
supplier_deliveries AS (
    SELECT
        d.sup_id,
        dd.item_id,
        SUM(dd.qty_received)            AS total_qty_delivered,
        COUNT(DISTINCT d.delivery_id)   AS delivery_count
    FROM delivery_detail    dd
    JOIN delivery           d  ON d.delivery_id = dd.delivery_id
    WHERE d.delivery_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY d.sup_id, dd.item_id
),
item_waste AS (
    SELECT
        id.item_id,
        SUM(id.waste)           AS total_waste,
        SUM(id.daily_usage)     AS total_usage
    FROM inventory_detail   id
    JOIN inventory_log      il ON il.log_id = id.log_id
    WHERE il.log_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY id.item_id
)
SELECT
    s.sup_name                              AS supplier,
    i.item_name,
    c.cat_name                              AS category,
    sd.delivery_count,
    ROUND(sd.total_qty_delivered, 2)        AS qty_delivered,
    ROUND(iw.total_waste, 2)                AS item_waste,
    ROUND(iw.total_usage, 2)                AS item_usage,
    ROUND(
        (iw.total_waste / NULLIF(iw.total_usage, 0)) * 100,
    2)                                      AS waste_rate_pct
FROM supplier_deliveries    sd
JOIN supplier               s  ON s.sup_id  = sd.sup_id
JOIN item                   i  ON i.item_id = sd.item_id
JOIN category               c  ON c.cat_id  = i.cat_id
LEFT JOIN item_waste        iw ON iw.item_id = sd.item_id
ORDER BY waste_rate_pct DESC NULLS LAST;
