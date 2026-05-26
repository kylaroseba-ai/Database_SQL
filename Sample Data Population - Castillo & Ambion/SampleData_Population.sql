-- ------------------------------------------------------------
-- Additional Employees (beyond the 2 seeded in the schema)
-- ------------------------------------------------------------
INSERT INTO employee (emp_name, role, is_active) VALUES
    ('Maria Santos',    'Staff',             TRUE),
    ('Jun Reyes',       'Staff',             TRUE),
    ('Ana Dela Cruz',   'Manager',           TRUE);


-- ------------------------------------------------------------
-- INVENTORY LOGS
-- Three days of data: Apr 16, Apr 17, Apr 18
-- Opening shift → emp_id 2 (Norjay Magboo, Assistant Head Chef)
-- Closing shift → emp_id 1 (Jessie Dayawon, Head Chef)
-- ------------------------------------------------------------
INSERT INTO inventory_log (log_date, shift, emp_id) VALUES
    ('2025-04-16', 'Opening', 2),   -- log_id = 1
    ('2025-04-16', 'Closing', 1),   -- log_id = 2
    ('2025-04-17', 'Opening', 2),   -- log_id = 3
    ('2025-04-17', 'Closing', 1),   -- log_id = 4
    ('2025-04-18', 'Opening', 2),   -- log_id = 5
    ('2025-04-18', 'Closing', 1);   -- log_id = 6


-- ------------------------------------------------------------
-- DELIVERIES
-- One delivery on Apr 17 (frozen meats from PJC MEAT)
-- One delivery on Apr 18 (produce from 3KA)
-- received_by = 2 (Assistant Head Chef), verified_by = 1 (Head Chef)
-- ------------------------------------------------------------
INSERT INTO delivery (sup_id, received_by, verified_by, delivery_date) VALUES
    (1, 2, 1, '2025-04-17'),   -- delivery_id = 1 | PJC MEAT
    (3, 2, 1, '2025-04-18');   -- delivery_id = 2 | 3KA


-- ------------------------------------------------------------
-- DELIVERY DETAILS
-- delivery_id 1: Frozen meats restocked on Apr 17
-- delivery_id 2: Local ingredients restocked on Apr 18
-- item_id references (from schema seed):
--   1=Pork Belly | 2=Pork Shoulder | 3=Beef Shortplate | 4=Chicken(Frozen)
--   44=Soy Sauce | 45=Vinegar | 46=White Sugar | 51=Rice
-- ------------------------------------------------------------
INSERT INTO delivery_detail (delivery_id, item_id, qty_received) VALUES
    -- Apr 17 Meat Delivery
    (1, 1,  50000.00),  -- Pork Belly        50 kg
    (1, 2,  20000.00),  -- Pork Shoulder     20 kg
    (1, 3,  25000.00),  -- Beef Shortplate   25 kg
    (1, 4,  10000.00),  -- Chicken (Frozen)  10 kg

    -- Apr 18 Ingredients Delivery
    (2, 44,  8000.00),  -- Soy Sauce          8 kg
    (2, 45,  4000.00),  -- Vinegar            4 kg
    (2, 46, 10000.00),  -- White Sugar       10 kg
    (2, 51, 50000.00);  -- Rice              50 kg


-- ------------------------------------------------------------
-- INVENTORY DETAILS — April 16 (log_id 1 = Opening, log_id 2 = Closing)
-- Sourced as realistic pre-April-18 baseline figures.
-- daily_usage is auto-calculated by the trigger.
-- ------------------------------------------------------------

-- Apr 16 Opening (log_id = 1)
INSERT INTO inventory_detail (log_id, item_id, opening, additions, addition_source, closing, waste) VALUES
    -- FROZEN MEATS
    (1, 1,  140000, 0,     NULL,      115000, 0),    -- Pork Belly
    (1, 2,   60000, 0,     NULL,       50000, 0),    -- Pork Shoulder
    (1, 3,   65000, 0,     NULL,       58000, 0),    -- Beef Shortplate
    (1, 4,   25000, 0,     NULL,       21000, 0),    -- Chicken (Frozen)

    -- READY-FOR-SERVING MEATS
    (1, 5,    7500, 3000, 'Prep',       7200, 300),  -- Samgyupsal
    (1, 6,    8000, 4500, 'Prep',       8100, 200),  -- Daepae
    (1, 7,    6000, 1500, 'Prep',       4900, 100),  -- Enoki
    (1, 8,   11000, 0,   'Prep',        7500, 0),    -- Gochujang w Sauce
    (1, 9,    8000, 5000, 'Prep',       9500, 0),    -- Y Sam w Sauce
    (1, 10,   4200, 3800, 'Prep',       5200, 100),  -- Moksal
    (1, 11,  10000, 2000, 'Prep',       9000, 0),    -- Plain Beef
    (1, 12,  16000, 0,   'Prep',       11000, 0),    -- Y Woo Beef w Sauce

    -- VEGETABLES
    (1, 13,   3500, 0,   NULL,          3128, 0),    -- Lettuce
    (1, 14,   2000, 0,   NULL,          1694, 0),    -- White Onion
    (1, 15,    500, 0,   NULL,           464, 0),    -- Peeled Garlic
    (1, 16,    360, 0,   NULL,           342, 0),    -- Ginger
    (1, 17,   1500, 0,   NULL,          1332, 0),    -- Cabbage
    (1, 18,    160, 0,   NULL,           144, 0),    -- Carrots
    (1, 19,    800, 0,   NULL,           734, 0),    -- Onion Leeks
    (1, 20,   2200, 0,   NULL,          2000, 0),    -- Potato Marble
    (1, 21,   2500, 0,   NULL,          2200, 0),    -- Raddish
    (1, 22,      4, 0,   NULL,             3, 0),    -- Enoki Mushroom Pack
    (1, 23,    240, 0,   NULL,           218, 0),    -- Eggs

    -- SIDE DISHES
    (1, 24,    700, 2200, 'Produce',     664, 0),    -- Chicken (Side Dish)
    (1, 25,   4800, 0,   'Produce',     4392, 0),    -- Meat Balls
    (1, 26,   1000, 4000, 'Produce',     906, 0),    -- Potato Marbles
    (1, 27,      0, 1500, 'Produce',       0, 0),    -- Fishcake
    (1, 28,   1200, 1200, 'Produce',    1094, 0),    -- Japchae
    (1, 29,   2800, 3200, 'Produce',    2664, 0),    -- Kimchi (Side Dish)
    (1, 30,   2300, 3200, 'Produce',    2170, 0),    -- Raddish (Side Dish)
    (1, 31,    300, 0,   'Produce',      278, 0),    -- Korean Salad
    (1, 32,   5500, 0,   'Produce',     5264, 0),    -- Sliced Cheese
    (1, 33,   8000, 0,   'Produce',     7492, 0),    -- Steam Egg
    (1, 34,    130, 600, 'Produce',      122, 0),    -- Lettuce (Side Dish)

    -- SAUCES
    (1, 35,  27000, 0,   'Produce',    26430, 0),    -- Yangyum Meat Sauce
    (1, 36,  13000, 0,   'Produce',    12000, 0),    -- Gochujang Meat Sauce
    (1, 37,   7800, 0,   'Produce',     7474, 0),    -- Samjang Dip Sauce
    (1, 38,   7600, 0,   'Produce',     7259, 0),    -- Bulgogi Dip Sauce
    (1, 39,  19000, 0,   'Produce',    18303, 0),    -- Hot Dip Sauce

    -- LOCAL INGREDIENTS (selected high-usage items)
    (1, 44,  17000, 0,   'Stock',      16150, 0),    -- Soy Sauce
    (1, 45,   7000, 0,   'Stock',       6544, 0),    -- Vinegar
    (1, 46,  24000, 0,   'Stock',      22822, 0),    -- White Sugar
    (1, 47,   1800, 0,   'Stock',       1686, 0),    -- Seasoning Salt
    (1, 48,   3700, 0,   'Stock',       3519, 0),    -- Sesame Oil
    (1, 49,  32000, 0,   'Stock',      30910, 0),    -- Cooking Oil
    (1, 51,  110000,0,   'Stock',     102505, 0),    -- Rice
    (1, 52,  27500, 0,   'Stock',      26852, 0),    -- Melted Cheese

    -- CHARCOAL
    (1, 77,  21000, 0,   NULL,         20000, 0);    -- Premium Charcoal


-- Apr 16 Closing (log_id = 2) — closing figures become next day's opening
INSERT INTO inventory_detail (log_id, item_id, opening, additions, addition_source, closing, waste) VALUES
    -- FROZEN MEATS
    (2, 1,  115000, 0,     NULL,      109000, 200),
    (2, 2,   50000, 0,     NULL,       46000, 0),
    (2, 3,   58000, 0,     NULL,       53500, 0),
    (2, 4,   21000, 0,     NULL,       20000, 0),

    -- READY-FOR-SERVING MEATS
    (2, 5,    7200, 2800, 'Prep',       6812, 200),
    (2, 6,    8100, 4500, 'Prep',       7596, 100),
    (2, 7,    4900, 2000, 'Prep',       5872, 0),
    (2, 8,    7500, 3500, 'Prep',      10264, 0),
    (2, 9,    9500, 4500, 'Prep',       7642, 0),
    (2, 10,   5200, 3000, 'Prep',       4040, 0),
    (2, 11,   9000, 2500, 'Prep',       9973, 0),
    (2, 12,  11000, 5000, 'Prep',      15652, 0),

    -- SAUCES
    (2, 35,  26430, 0,   'Produce',    26430, 0),
    (2, 36,  12000, 0,   'Produce',    12000, 0),
    (2, 37,   7474, 0,   'Produce',     7474, 0),
    (2, 38,   7259, 0,   'Produce',     7259, 0),
    (2, 39,  18303, 0,   'Produce',    18303, 0),

    -- LOCAL INGREDIENTS
    (2, 44,  16150, 0,   'Stock',      16150, 0),
    (2, 45,   6544, 0,   'Stock',       6544, 0),
    (2, 46,  22822, 0,   'Stock',      22822, 0),
    (2, 51, 102505, 0,   'Stock',     102505, 0),

    -- CHARCOAL
    (2, 77,  20000, 0,   NULL,         20000, 0);


-- ------------------------------------------------------------
-- Apr 17 Opening (log_id = 3) — with meat delivery
-- ------------------------------------------------------------
INSERT INTO inventory_detail (log_id, item_id, opening, additions, addition_source, closing, waste) VALUES
    -- FROZEN MEATS (delivery added today)
    (3, 1,  109000, 50000, 'Delivery', 130000, 0),   -- Pork Belly +50kg delivery
    (3, 2,   46000, 20000, 'Delivery',  58000, 0),   -- Pork Shoulder +20kg
    (3, 3,   53500, 25000, 'Delivery',  65000, 0),   -- Beef Shortplate +25kg
    (3, 4,   20000, 10000, 'Delivery',  24000, 0),   -- Chicken +10kg

    -- READY-FOR-SERVING MEATS
    (3, 5,    6812, 3200, 'Prep',       7600, 0),
    (3, 6,    7596, 5500, 'Prep',       8800, 0),
    (3, 7,    5872, 2000, 'Prep',       6200, 0),
    (3, 8,   10264, 0,   'Prep',       10500, 0),
    (3, 9,    7642, 6000, 'Prep',       8500, 0),
    (3, 10,   4040, 4000, 'Prep',       5000, 0),
    (3, 11,   9973, 3000, 'Prep',      10500, 0),
    (3, 12,  15652, 0,   'Prep',       15000, 0),

    -- SAUCES
    (3, 35,  26430, 0,   'Produce',    26000, 0),
    (3, 36,  12000, 0,   'Produce',    12000, 0),
    (3, 37,   7474, 0,   'Produce',     7300, 0),
    (3, 38,   7259, 0,   'Produce',     7000, 0),
    (3, 39,  18303, 0,   'Produce',    18000, 0),

    -- LOCAL INGREDIENTS (delivery on Apr 18, not yet received)
    (3, 44,  16150, 0,   'Stock',      16150, 0),
    (3, 45,   6544, 0,   'Stock',       6544, 0),
    (3, 46,  22822, 0,   'Stock',      22822, 0),
    (3, 51, 102505, 0,   'Stock',     102505, 0),

    -- CHARCOAL
    (3, 77,  20000, 0,   NULL,         19800, 0);


-- Apr 17 Closing (log_id = 4)
INSERT INTO inventory_detail (log_id, item_id, opening, additions, addition_source, closing, waste) VALUES
    -- FROZEN MEATS
    (4, 1,  130000, 0,   NULL,        108850, 200),
    (4, 2,   58000, 0,   NULL,         45721, 0),
    (4, 3,   65000, 0,   NULL,         53132, 0),
    (4, 4,   24000, 0,   NULL,         19790, 0),

    -- READY-FOR-SERVING MEATS
    (4, 5,    7600, 2954, 'Prep',       6812, 0),
    (4, 6,    8800, 5063, 'Prep',       7596, 0),
    (4, 7,    6200, 1456, 'Prep',       5872, 0),
    (4, 8,   10500, 0,   'Prep',       10264, 0),
    (4, 9,    8500, 5500, 'Prep',       7642, 0),
    (4, 10,   5000, 3502, 'Prep',       4040, 0),
    (4, 11,  10500, 2046, 'Prep',       9973, 0),
    (4, 12,  15000, 5500, 'Prep',      15652, 0),

    -- SAUCES
    (4, 35,  26000, 0,   'Produce',    26430, 0),
    (4, 36,  12000, 0,   'Produce',    12000, 0),
    (4, 37,   7300, 0,   'Produce',     7474, 0),
    (4, 38,   7000, 0,   'Produce',     7259, 0),
    (4, 39,  18000, 0,   'Produce',    18303, 0),

    -- LOCAL INGREDIENTS
    (4, 44,  16150, 0,   'Stock',      16150, 0),
    (4, 45,   6544, 0,   'Stock',       6544, 0),
    (4, 46,  22822, 0,   'Stock',      22822, 0),
    (4, 51, 102505, 0,   'Stock',     102505, 0),

    -- CHARCOAL
    (4, 77,  19800, 0,   NULL,         20000, 0);


-- ------------------------------------------------------------
-- Apr 18 Opening (log_id = 5) — the actual inventory sheet date
-- ------------------------------------------------------------
INSERT INTO inventory_detail (log_id, item_id, opening, additions, addition_source, closing, waste) VALUES
    -- FROZEN MEATS
    (5, 1,  108850, 0,     NULL,      100660, 200),
    (5, 2,   45721, 0,     NULL,       38219, 0),
    (5, 3,   53132, 0,     NULL,       51086, 0),
    (5, 4,   19790, 0,     NULL,       17790, 0),

    -- READY-FOR-SERVING MEATS
    (5, 5,    6812, 2954, 'Prep',       7504, 0),
    (5, 6,    7596, 5063, 'Prep',       8520, 0),
    (5, 7,    5872, 1456, 'Prep',       4798, 0),
    (5, 8,   10264, 0,   'Prep',        6655, 0),
    (5, 9,    7642, 5500, 'Prep',       9638, 0),
    (5, 10,   4040, 3502, 'Prep',       5074, 0),
    (5, 11,   9973, 2046, 'Prep',       8589, 0),
    (5, 12,  15652, 0,   'Prep',       10534, 0),

    -- VEGETABLES
    (5, 13,   3128, 0,   NULL,          1524, 0),
    (5, 14,   1694, 0,   NULL,          1262, 0),
    (5, 15,    464, 0,   NULL,           450, 0),
    (5, 16,    342, 0,   NULL,           342, 0),
    (5, 17,   1332, 0,   NULL,           804, 0),
    (5, 18,    144, 0,   NULL,           136, 0),
    (5, 19,    734, 0,   NULL,           392, 0),
    (5, 20,   2000, 0,   NULL,             0, 0),
    (5, 21,   2200, 0,   NULL,             0, 0),
    (5, 22,      3, 0,   NULL,             3, 0),
    (5, 23,    218, 0,   NULL,           217, 0),

    -- SIDE DISHES
    (5, 24,    664, 2412, 'Produce',     672, 0),
    (5, 25,   4392, 0,   'Produce',     3862, 0),
    (5, 26,    906, 4192, 'Produce',    2582, 0),
    (5, 27,      0, 1424, 'Produce',     436, 0),
    (5, 28,   1094, 1270, 'Produce',     156, 0),
    (5, 29,   2664, 3420, 'Produce',    2524, 0),
    (5, 30,   2170, 3474, 'Produce',    3308, 0),
    (5, 31,    278, 0,   'Produce',      218, 0),
    (5, 32,   5264, 0,   'Produce',     4170, 0),
    (5, 33,   7492, 0,   'Produce',     5516, 0),
    (5, 34,    122, 626, 'Produce',      626, 0),

    -- SAUCES
    (5, 35,  26430, 0,   'Produce',    24930, 0),
    (5, 36,  12000, 0,   'Produce',    12000, 0),
    (5, 37,   7474, 0,   'Produce',     7194, 0),
    (5, 38,   7259, 0,   'Produce',     6691, 0),
    (5, 39,  18303, 0,   'Produce',    17550, 0),

    -- LOCAL INGREDIENTS
    (5, 44,  16150, 0,   'Stock',      15819, 0),    -- Soy Sauce
    (5, 45,   6544, 0,   'Stock',       6094, 0),    -- Vinegar
    (5, 46,  22822, 0,   'Stock',      21600, 0),    -- White Sugar
    (5, 47,   1686, 0,   'Stock',       1662, 0),    -- Seasoning Salt
    (5, 48,   3519, 0,   'Stock',       3369, 0),    -- Sesame Oil
    (5, 49,  30910, 0,   'Stock',      30600, 0),    -- Cooking Oil
    (5, 51, 102505, 0,   'Stock',      98305, 0),    -- Rice
    (5, 52,  26852, 0,   'Stock',      24934, 0),    -- Melted Cheese

    -- KOREAN INGREDIENTS
    (5, 57,   1298, 0,   'Stock',       1240, 0),    -- Rock Salt
    (5, 58,  12700, 0,   'Stock',      12500, 0),    -- Mulyot
    (5, 59,   4160, 0,   'Stock',       4000, 0),    -- Dashida
    (5, 60,   1496, 0,   'Stock',       1472, 0),    -- MSG
    (5, 62,    133, 0,   'Stock',        121, 0),    -- Black Pepper
    (5, 63,  19144, 0,   'Stock',      18740, 0),    -- Frying Powder
    (5, 65,    660, 0,   'Stock',        640, 0),    -- Chili Powder
    (5, 69,  23422, 0,   'Stock',      19711, 0),    -- Kimchi (Korean Ing.)
    (5, 70,   4600, 0,   'Stock',       3400, 0),    -- Glass Noodles

    -- CHARCOAL
    (5, 77,  20000, 0,   NULL,         19500, 500),  -- Premium Charcoal

    -- DELIVERY MATERIALS
    (5, 90,    916, 0,   NULL,           871,  0);   -- Ice Cream Cup


-- Apr 18 Closing (log_id = 6) — end-of-day totals
INSERT INTO inventory_detail (log_id, item_id, opening, additions, addition_source, closing, waste) VALUES
    -- FROZEN MEATS (closing stock becomes next day's opening)
    (6, 1,  100660, 0,   NULL,        92000, 200),
    (6, 2,   38219, 0,   NULL,        31000, 0),
    (6, 3,   51086, 0,   NULL,        49000, 0),
    (6, 4,   17790, 0,   NULL,        15000, 0),

    -- READY-FOR-SERVING MEATS
    (6, 5,    7504, 2800, 'Prep',      6200, 200),
    (6, 6,    8520, 4800, 'Prep',      7200, 0),
    (6, 7,    4798, 1800, 'Prep',      5000, 0),
    (6, 8,    6655, 4000, 'Prep',      9100, 0),
    (6, 9,    9638, 4000, 'Prep',      8500, 0),
    (6, 10,   5074, 3000, 'Prep',      4200, 0),
    (6, 11,   8589, 2500, 'Prep',      9000, 0),
    (6, 12,  10534, 5500, 'Prep',     14000, 0),

    -- SAUCES
    (6, 35,  24930, 0,   'Produce',   24800, 0),
    (6, 36,  12000, 0,   'Produce',   12000, 0),
    (6, 37,   7194, 0,   'Produce',    7100, 0),
    (6, 38,   6691, 0,   'Produce',    6500, 0),
    (6, 39,  17550, 0,   'Produce',   17300, 0),

    -- LOCAL INGREDIENTS (Apr 18 delivery added)
    (6, 44,  15819, 8000, 'Delivery', 23000, 0),     -- Soy Sauce
    (6, 45,   6094, 4000, 'Delivery',  9800, 0),     -- Vinegar
    (6, 46,  21600,10000, 'Delivery', 30500, 0),     -- White Sugar
    (6, 51,  98305,50000, 'Delivery',145000, 0),     -- Rice

    -- CHARCOAL
    (6, 77,  19500, 0,   NULL,        19000, 0);


-- ------------------------------------------------------------
-- INVENTORY AUDIT — Sample corrections
-- emp_id 1 (Head Chef) corrected two entries from Apr 18
-- ------------------------------------------------------------

-- Correction 1: Pork Belly waste was 0, corrected to 200
-- SET LOCAL app.current_emp_id = '1';
-- SET LOCAL app.change_reason = 'Shift staff missed logging spoiled end-cut during closing. Verified with physical count.';
-- (The trigger fires automatically on UPDATE — these are shown here for documentation)
-- Manually inserting audit records to represent post-submission corrections:

INSERT INTO inventory_audit (detail_id, emp_id, field_changed, old_val, new_val, changed_at, reason)
VALUES
    -- detail_id for Apr 18 Opening Pork Belly = row with log_id=5, item_id=1
    (
        (SELECT detail_id FROM inventory_detail WHERE log_id = 5 AND item_id = 1),
        1,
        'waste',
        0.00,
        200.00,
        '2025-04-18 22:10:00',
        'Shift staff missed logging spoiled end-cut during closing. Verified with physical count.'
    ),
    -- Correction 2: Kimchi (Korean Ingredient) closing adjusted by manager
    (
        (SELECT detail_id FROM inventory_detail WHERE log_id = 5 AND item_id = 69),
        1,
        'closing',
        19900.00,
        19711.00,
        '2025-04-18 22:35:00',
        'Physical recount showed lower closing value. Discrepancy traced to unrecorded prep use during lunch rush.'
    );

