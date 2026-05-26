-- ============================================================
-- Query 7: Detecting Consecutive Low-Stock Sessions Per Item
-- Technique: Island-and-gap pattern, ROW_NUMBER() OVER
-- ============================================================

WITH
session_flags AS (
    SELECT
        id.item_id,
        i.item_name,
        c.cat_name,
        il.log_date,
        il.shift,
        id.closing,
        -- Flag session as low-stock when closing drops below 500 units
        CASE
            WHEN id.closing < 500 THEN 1
            ELSE 0
        END                                         AS is_low_stock,
        ROW_NUMBER() OVER (
            PARTITION BY id.item_id
            ORDER BY il.log_date, il.shift
        )                                           AS session_seq
    FROM inventory_detail   id
    JOIN inventory_log      il ON il.log_id  = id.log_id
    JOIN item               i  ON i.item_id  = id.item_id
    JOIN category           c  ON c.cat_id   = i.cat_id
),
-- Island-and-gap technique: subtract session sequence from a
-- running count of low-stock rows to create stable group IDs
low_stock_groups AS (
    SELECT
        *,
        session_seq - ROW_NUMBER() OVER (
            PARTITION BY item_id, is_low_stock
            ORDER BY log_date, shift
        )                                           AS grp
    FROM session_flags
    WHERE is_low_stock = 1
),
streaks AS (
    SELECT
        item_id,
        item_name,
        cat_name,
        MIN(log_date)   AS streak_start,
        MAX(log_date)   AS streak_end,
        COUNT(*)        AS consecutive_low_sessions,
        MIN(closing)    AS lowest_closing_in_streak
    FROM low_stock_groups
    GROUP BY item_id, item_name, cat_name, grp
)
SELECT
    cat_name                                        AS category,
    item_name,
    streak_start,
    streak_end,
    consecutive_low_sessions,
    ROUND(lowest_closing_in_streak, 2)              AS lowest_stock_recorded,
    CASE
        WHEN consecutive_low_sessions >= 4 THEN 'CRITICAL SHORTAGE'
        WHEN consecutive_low_sessions >= 2 THEN 'ONGOING LOW STOCK'
        ELSE                                    'SINGLE LOW EVENT'
    END                                             AS shortage_severity
FROM streaks
ORDER BY consecutive_low_sessions DESC, streak_end DESC;
