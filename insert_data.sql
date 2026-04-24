-- ============================================================
-- Choco-K29: Sample Data
-- Inserting Values to use for the quiries
-- ============================================================

-- CUSTOMERS
INSERT INTO customers (cust_name, street, number, town, postcode, cr_limit, curr_balance)
VALUES
    ('Athenian Sweets SA',     'Ermou',     '14', 'Athens',       '10563', 15000.00, 8200.00),
    ('Thessaloniki Choco Ltd', 'Tsimiski',  '22', 'Thessaloniki', '54622', 12000.00, 3100.00),
    ('Xanthi Patisserie',      'Vasileos',  '5',  'Xanthi',       '67100',  8000.00, 1500.00),
    ('Athens Bakery Group',    'Stadiou',   '33', 'Athens',       '10559', 10000.00,  500.00),
    ('Crete Confections',      'Ikarou',    '7',  'Heraklion',    '71201',  6000.00, 6400.00),
    ('Patras Choco House',     'Korinthou', '18', 'Patras',       '26221',  9000.00,    0.00);

-- PRODUCTS
INSERT INTO products (prod_code, description, prod_origin, list_price, qty_on_hand, reorder_level, reorder_qty)
VALUES
    ('ALMOND-CH', 'Almond-Choco',        'WA', 18.50, 320.00, 200.00, 500.00),
    ('ORANGE-CH', 'OrangeChoco',         'SA', 22.00, 150.00, 300.00, 600.00),
    ('DARK-70',   'Dark Chocolate 70%',  'EA', 25.00,  80.00, 100.00, 400.00),
    ('MILK-STD',  'Milk Chocolate',      'CA', 15.00, 500.00, 250.00, 300.00),
    ('WHITE-VAN', 'White Vanilla Choco', 'AS', 20.00, 200.00, 150.00, 250.00),
    ('HAZEL-CH',  'Hazelnut Choco',      'WA', 30.00, 120.00,  80.00, 200.00),
    ('MINT-DK',   'Dark Mint Choco',     'SA', 28.00,  80.00,  50.00, 150.00);

-- ORDERS
INSERT INTO orders (order_date, cust_no)
VALUES
    ('2024-01-10', 1),
    ('2024-01-25', 2),
    ('2024-04-05', 3),
    ('2025-02-14', 1),
    ('2025-04-03', 1),
    ('2025-04-18', 2),
    ('2025-05-07', 4),
    ('2025-05-20', 2),
    ('2025-06-11', 1),
    ('2025-06-11', 2),
    ('2025-08-12', 3),
    ('2025-08-12', 1),
    ('2025-09-01', 5);

-- Q16: orphan order — temporarily disable FK to allow cust_no=999
ALTER TABLE orders DROP CONSTRAINT fk_orders_customer;

INSERT INTO orders (order_date, cust_no)
VALUES ('2025-03-15', 999);

ALTER TABLE orders
    ADD CONSTRAINT fk_orders_customer
    FOREIGN KEY (cust_no)
    REFERENCES customers(cust_no)
    ON UPDATE CASCADE ON DELETE RESTRICT
    NOT VALID;

-- ORDER_DETAILS
INSERT INTO order_details (order_no, prod_code, order_qty, order_price)
VALUES
    (1,  'DARK-70',    50.00, 25.00),
    (1,  'MILK-STD',  100.00, 15.00),
    (2,  'DARK-70',    80.00, 24.00),
    (2,  'ALMOND-CH',  60.00, 18.50),
    (3,  'MILK-STD',  200.00, 15.00),
    (3,  'WHITE-VAN', 100.00, 20.00),
    (4,  'ORANGE-CH',  50.00, 22.00),
    (5,  'ALMOND-CH', 150.00, 18.50),
    (5,  'DARK-70',   600.00, 25.00),
    (6,  'ALMOND-CH', 200.00, 17.00),
    (7,  'MINT-DK',    80.00, 28.00),
    (7,  'MILK-STD',  120.00, 15.00),
    (8,  'MINT-DK',   100.00, 28.00),
    (9,  'ORANGE-CH', 500.00, 22.00),
    (9,  'HAZEL-CH',  400.00, 30.00),
    (10, 'DARK-70',   300.00, 25.00),
    (10, 'MILK-STD',  400.00, 15.00),
    (11, 'WHITE-VAN', 150.00, 20.00),
    (11, 'ALMOND-CH', 200.00, 18.50),
    (12, 'ORANGE-CH', 300.00, 21.00),
    (12, 'MINT-DK',   200.00, 28.00),
    (13, 'HAZEL-CH',  100.00, 30.00),
    (13, 'ORANGE-CH', 200.00, 22.00);

-- Stock correction for Q2 (only ORANGE-CH and DARK-70 below reorder level)
UPDATE products SET qty_on_hand = 120.00 WHERE prod_code = 'HAZEL-CH';
UPDATE products SET qty_on_hand = 80.00  WHERE prod_code = 'MINT-DK';
