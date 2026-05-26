SELECT
    s.sup_name          AS supplier,
    d.delivery_date,
    i.item_name,
    u.unit_abbr         AS unit,
    dd.qty_received
FROM delivery_detail    dd
JOIN delivery           d  ON d.delivery_id = dd.delivery_id
JOIN supplier           s  ON s.sup_id      = d.sup_id
JOIN item               i  ON i.item_id     = dd.item_id
JOIN unit               u  ON u.unit_id     = i.unit_id
ORDER BY d.delivery_date, s.sup_name, i.item_name;
