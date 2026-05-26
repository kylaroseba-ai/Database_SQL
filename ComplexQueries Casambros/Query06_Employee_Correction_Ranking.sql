-- ============================================================
-- Query 6: Employee Correction Ranking and Anomaly Detection
-- Technique: CTE, RANK() OVER, EXTRACT(), AVG() OVER, CASE WHEN
-- ============================================================

WITH
emp_audit_summary AS (
    SELECT
        ia.emp_id,
        COUNT(ia.audit_id)                          AS total_corrections,
        COUNT(ia.audit_id)
            FILTER (WHERE EXTRACT(HOUR FROM ia.changed_at)
                         NOT BETWEEN 6 AND 22)      AS after_hours_corrections,
        MIN(ia.changed_at)                          AS first_correction,
        MAX(ia.changed_at)                          AS last_correction,
        ROUND(AVG(ABS(ia.new_val - ia.old_val)), 2) AS avg_change_magnitude
    FROM inventory_audit ia
    WHERE ia.changed_at >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY ia.emp_id
)
SELECT
    e.emp_name,
    e.role,
    eas.total_corrections,
    eas.after_hours_corrections,
    ROUND(eas.avg_change_magnitude, 2)      AS avg_change_magnitude,
    RANK() OVER (
        ORDER BY eas.total_corrections DESC
    )                                       AS correction_rank,
    ROUND(AVG(eas.total_corrections) OVER (), 2) AS group_avg_corrections,
    CASE
        WHEN eas.after_hours_corrections > 0
         AND eas.total_corrections > AVG(eas.total_corrections) OVER () * 1.5
            THEN 'HIGH RISK'
        WHEN eas.total_corrections > AVG(eas.total_corrections) OVER () * 1.5
            THEN 'ELEVATED ACTIVITY'
        WHEN eas.after_hours_corrections > 0
            THEN 'AFTER-HOURS FLAG'
        ELSE 'NORMAL'
    END                                     AS anomaly_flag
FROM emp_audit_summary  eas
JOIN employee           e  ON e.emp_id = eas.emp_id
ORDER BY correction_rank;
