-- ============================================================
-- Query 11: Shift Comparison — Opening vs. Closing Usage
-- Technique: Conditional AVG FILTER per shift, delta, CASE WHEN
-- ============================================================

SELECT
    c.cat_name                              AS category,
    i.item_name,
    u.unit_abbr                             AS unit,
    ROUND(AVG(id.daily_usage)
        FILTER (WHERE il.shift = 'Opening'), 2) AS avg_opening_usage,
    ROUND(AVG(id.daily_usage)
        FILTER (WHERE il.shift = 'Closing'), 2) AS avg_closing_usage,
    ROUND(
        AVG(id.daily_usage) FILTER (WHERE il.shift = 'Opening')
        - AVG(id.daily_usage) FILTER (WHERE il.shift = 'Closing')
    , 2)                                    AS opening_vs_closing_delta,
    CASE
        WHEN AVG(id.daily_usage) FILTER (WHERE il.shift = 'Opening')
             > AVG(id.daily_usage) FILTER (WHERE il.shift = 'Closing') * 1.3
            THEN 'OPENING-HEAVY'
        WHEN AVG(id.daily_usage) FILTER (WHERE il.shift = 'Closing')
             > AVG(id.daily_usage) FILTER (WHERE il.shift = 'Opening') * 1.3
            THEN 'CLOSING-HEAVY'
        ELSE 'BALANCED'
    END                                     AS shift_distribution
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id = id.log_id
JOIN item               i  ON i.item_id = id.item_id
JOIN category           c  ON c.cat_id  = i.cat_id
JOIN unit               u  ON u.unit_id = i.unit_id
GROUP BY c.cat_name, i.item_name, u.unit_abbr
HAVING COUNT(DISTINCT il.shift) = 2
ORDER BY ABS(
    COALESCE(AVG(id.daily_usage) FILTER (WHERE il.shift = 'Opening'), 0)
    - COALESCE(AVG(id.daily_usage) FILTER (WHERE il.shift = 'Closing'), 0)
) DESC;
