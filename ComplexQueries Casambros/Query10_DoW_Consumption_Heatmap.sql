-- ============================================================
-- Query 10: Category-Level Consumption Heatmap by Day of Week
-- Technique: EXTRACT(DOW), conditional AVG FILTER per day (pivot)
-- ============================================================

SELECT
    c.cat_name                              AS category,
    ROUND(AVG(id.daily_usage)
        FILTER (WHERE EXTRACT(DOW FROM il.log_date) = 0), 2) AS sunday,
    ROUND(AVG(id.daily_usage)
        FILTER (WHERE EXTRACT(DOW FROM il.log_date) = 1), 2) AS monday,
    ROUND(AVG(id.daily_usage)
        FILTER (WHERE EXTRACT(DOW FROM il.log_date) = 2), 2) AS tuesday,
    ROUND(AVG(id.daily_usage)
        FILTER (WHERE EXTRACT(DOW FROM il.log_date) = 3), 2) AS wednesday,
    ROUND(AVG(id.daily_usage)
        FILTER (WHERE EXTRACT(DOW FROM il.log_date) = 4), 2) AS thursday,
    ROUND(AVG(id.daily_usage)
        FILTER (WHERE EXTRACT(DOW FROM il.log_date) = 5), 2) AS friday,
    ROUND(AVG(id.daily_usage)
        FILTER (WHERE EXTRACT(DOW FROM il.log_date) = 6), 2) AS saturday,
    ROUND(AVG(id.daily_usage), 2)           AS overall_avg
FROM inventory_detail   id
JOIN inventory_log      il ON il.log_id = id.log_id
JOIN item               i  ON i.item_id = id.item_id
JOIN category           c  ON c.cat_id  = i.cat_id
GROUP BY c.cat_name
ORDER BY overall_avg DESC;
