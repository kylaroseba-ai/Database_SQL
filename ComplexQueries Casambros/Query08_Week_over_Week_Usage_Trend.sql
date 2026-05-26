-- ============================================================
-- Query 8: Week-over-Week Usage Trend with Percentage Change
-- Technique: DATE_TRUNC, LAG() OVER, NULLIF division guard
-- ============================================================

WITH
weekly_usage AS (
    SELECT
        c.cat_name,
        i.item_name,
        u.unit_abbr                             AS unit,
        DATE_TRUNC('week', il.log_date)::DATE   AS week_start,
        SUM(id.daily_usage)                     AS weekly_usage,
        SUM(id.waste)                           AS weekly_waste,
        COUNT(DISTINCT il.log_date)             AS days_logged
    FROM inventory_detail   id
    JOIN inventory_log      il ON il.log_id = id.log_id
    JOIN item               i  ON i.item_id = id.item_id
    JOIN category           c  ON c.cat_id  = i.cat_id
    JOIN unit               u  ON u.unit_id = i.unit_id
    GROUP BY c.cat_name, i.item_name, u.unit_abbr,
             DATE_TRUNC('week', il.log_date)
),
with_lag AS (
    SELECT
        *,
        LAG(weekly_usage) OVER (
            PARTITION BY cat_name, item_name
            ORDER BY week_start
        )                                       AS prev_week_usage,
        LAG(weekly_waste) OVER (
            PARTITION BY cat_name, item_name
            ORDER BY week_start
        )                                       AS prev_week_waste,
        LAG(week_start) OVER (
            PARTITION BY cat_name, item_name
            ORDER BY week_start
        )                                       AS prev_week_start
    FROM weekly_usage
)
SELECT
    cat_name                AS category,
    item_name,
    unit,
    week_start              AS current_week,
    prev_week_start         AS previous_week,
    ROUND(weekly_usage, 2)          AS current_usage,
    ROUND(prev_week_usage, 2)       AS previous_usage,
    ROUND(weekly_usage - COALESCE(prev_week_usage, 0), 2) AS usage_delta,
    CASE
        WHEN prev_week_usage IS NULL OR prev_week_usage = 0 THEN NULL
        ELSE ROUND(((weekly_usage - prev_week_usage)
                   / prev_week_usage) * 100, 1)
    END                             AS pct_change,
    CASE
        WHEN prev_week_usage IS NULL            THEN 'BASELINE'
        WHEN weekly_usage > prev_week_usage * 1.20 THEN 'SURGE (+20%)'
        WHEN weekly_usage < prev_week_usage * 0.80 THEN 'DROP (-20%)'
        ELSE                                         'STABLE'
    END                             AS trend_flag
FROM with_lag
ORDER BY ABS(COALESCE(
    (weekly_usage - prev_week_usage)
    / NULLIF(prev_week_usage, 0), 0)) DESC, cat_name, item_name;
