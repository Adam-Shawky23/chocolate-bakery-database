-- ============================================================
-- Choco-K29: Table Creation
-- Customers, Products, Orders, Order Detail
-- ============================================================

CREATE TABLE customers (
    cust_no      SERIAL                PRIMARY KEY,
    cust_name    VARCHAR(100)          NOT NULL,
    street       VARCHAR(100),
    number       VARCHAR(10),
    town         VARCHAR(60)           NOT NULL,
    postcode     CHAR(5)
                 CHECK (postcode ~ '^[0-9]{5}$'),
    cr_limit     NUMERIC(10,2)         NOT NULL
                 CHECK (cr_limit > 0),
    curr_balance NUMERIC(10,2)         NOT NULL
                 DEFAULT 0.00
                 CHECK (curr_balance >= 0)
);

CREATE TABLE products (
    prod_code     VARCHAR(20)   PRIMARY KEY,
    description   VARCHAR(100)  NOT NULL,
    prod_origin   CHAR(2)       NOT NULL
                  CHECK (prod_origin IN ('SA','CA','WA','EA','AS')),
    list_price    NUMERIC(8,2)  NOT NULL
                  CHECK (list_price > 0),
    qty_on_hand   NUMERIC(10,2) NOT NULL
                  DEFAULT 0.00
                  CHECK (qty_on_hand >= 0),
    reorder_level NUMERIC(10,2) NOT NULL
                  CHECK (reorder_level > 0),
    reorder_qty   NUMERIC(10,2) NOT NULL
                  CHECK (reorder_qty >= 10)
);

CREATE TABLE orders (
    order_no   SERIAL    PRIMARY KEY,
    order_date DATE      NOT NULL,
    cust_no    INTEGER ,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (cust_no)
        REFERENCES customers(cust_no)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE order_details (
    order_no    INTEGER       NOT NULL,
    prod_code   VARCHAR(20)   NOT NULL,
    order_qty   NUMERIC(10,2) NOT NULL
                CHECK (order_qty >= 10),
    order_price NUMERIC(8,2)  NOT NULL
                CHECK (order_price > 0),
    PRIMARY KEY (order_no, prod_code),
    CONSTRAINT fk_det_order
        FOREIGN KEY (order_no)
        REFERENCES orders(order_no)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_det_product
        FOREIGN KEY (prod_code)
        REFERENCES products(prod_code)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
