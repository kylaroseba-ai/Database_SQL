-- ============================================================
-- Query 2: Waste-to-Usage Efficiency Report with Multi-CTE
-- Technique: 3-layer CTE chain, RANK() OVER, CASE WHEN
-- ============================================================

WITH
-- Step 1: Aggregate raw totals per item for the target period
item_totals AS (
    SELECT
        id.item_id,
        SUM(id.daily_usage)     AS total_usage,
        SUM(id.waste)           AS total_waste,
        COUNT(id.detail_id)     AS session_count
    FROM inventory_detail   id
    JOIN inventory_log      il ON il.log_id = id.log_id
    WHERE il.log_date BETWEEN '2026-05-01' AND '2026-05-31'
    GROUP BY id.item_id
),
-- Step 2: Calculate waste percentage and round
waste_pct AS (
    SELECT
        it.item_id,
        it.total_usage,
        it.total_waste,
        it.session_count,
        CASE
            WHEN it.total_usage = 0 THEN 0
            ELSE ROUND((it.total_waste / it.total_usage) * 100, 2)
        END                     AS waste_percentage
    FROM item_totals it
),
-- Step 3: Rank items within each category by waste percentage
ranked AS (
    SELECT
        wp.*,
        i.item_name,
        c.cat_name,
        u.unit_abbr             AS unit,
        RANK() OVER (
            PARTITION BY i.cat_id
            ORDER BY wp.waste_percentage DESC
        )                       AS rank_in_category
    FROM waste_pct      wp
    JOIN item           i  ON i.item_id  = wp.item_id
    JOIN category       c  ON c.cat_id   = i.cat_id
    JOIN unit           u  ON u.unit_id  = i.unit_id
)
SELECT
    cat_name            AS category,
    item_name,
    unit,
    ROUND(total_usage, 2)           AS total_usage,
    ROUND(total_waste, 2)           AS total_waste,
    waste_percentage,
    rank_in_category,
    CASE
        WHEN waste_percentage >= 20 THEN 'CRITICAL'
        WHEN waste_percentage >= 10 THEN 'HIGH'
        WHEN waste_percentage >= 5  THEN 'MODERATE'
        ELSE                             'ACCEPTABLE'
    END                             AS waste_severity
FROM ranked
WHERE waste_percentage >= 10
ORDER BY waste_percentage DESC, cat_name;
