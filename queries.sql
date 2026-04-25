-- ============================================================
-- Choco-K29: All 20 Queries
-- ============================================================

-- Q1: Παρουσίασε όλα τα ονόματα των πελατών ταξινομημένα με το ποιος/α οφείλει πιο πολλά
-- στην Choco-K29.

SELECT cust_name, curr_balance
FROM customers
ORDER BY curr_balance DESC;

-- Q2: Ποιοι κωδικοί προϊόντων θα πρέπει να παραγγελθούν άμεσα?

SELECT prod_code
FROM products
WHERE qty_on_hand < reorder_level;

-- Q3: Παρουσιάστε τα ονόματα όλων των πελατών που παράγγειλαν `Almond-Choco’ τον Απρίλιο του 2025

SELECT DISTINCT c.cust_name
FROM customers c
JOIN orders o ON c.cust_no = o.cust_no
JOIN order_details od ON o.order_no = od.order_no
JOIN products p ON od.prod_code = p.prod_code
WHERE p.description ILIKE '%Almond-Choco%'
  AND EXTRACT(MONTH FROM o.order_date) = 4
  AND EXTRACT(YEAR  FROM o.order_date) = 2025;

-- Q4: Παρουσιάστε τον prod_code, order_num, και order_date για όσες παραγγελίες η order_qty είναι μεγαλύτερη από την reorder_qty.

SELECT od.prod_code, o.order_no, o.order_date
FROM order_details od
JOIN orders o ON od.order_no = o.order_no
JOIN products p ON od.prod_code = p.prod_code
WHERE od.order_qty > p.reorder_qty;

-- Q5: Ποια είναι η η αξία και ο αριθμός της καλύτερης παραγγελίας για σοκολάτες τύπου“OrangeChoco”.

SELECT o.order_no, SUM(od.order_qty * od.order_price) AS order_value
FROM orders o
JOIN order_details od ON o.order_no = od.order_no
JOIN products p ON od.prod_code = p.prod_code
WHERE p.description ILIKE '%Orange%'
GROUP BY o.order_no
ORDER BY order_value DESC
LIMIT 1;

-- Q6: Παρουσίασε όλες τις πόλεις για τις οποίες το average credit limit των πελατών είναι πάνωαπό 9,000Ε.

SELECT town, AVG(cr_limit) AS avg_cr_limit
FROM customers
GROUP BY town
HAVING AVG(cr_limit) > 9000;

-- Q7: Για κάθε προϊόν (prod_code) βρες την μικρότερη και την μεγαλύτερη χρηματικάπ αραγγελίες που έχουν γίνει

SELECT prod_code,
       MIN(order_qty * order_price) AS min_order_value,
       MAX(order_qty * order_price) AS max_order_value
FROM order_details
GROUP BY prod_code;

-- Q8: Σε ποιες μέρες τον Ιούνιο του 2025 τον σύνολο των παραγγελιών που παρελήφθη εκείνητην μέρα ήταν μεγαλύτερο από 35,000 Ε;

SELECT o.order_date, SUM(od.order_qty * od.order_price) AS daily_total
FROM orders o
JOIN order_details od ON o.order_no = od.order_no
WHERE EXTRACT(MONTH FROM o.order_date) = 6
  AND EXTRACT(YEAR  FROM o.order_date) = 2025
GROUP BY o.order_date
HAVING SUM(od.order_qty * od.order_price) > 35000;

-- Q9: Για κάθε prod_code που παραγγέλθηκε τον Ιανουάριο του 2024, παρουσίασε τοprod_origin και τον αριθμό των πελατών που παράγγειλαν 

SELECT od.prod_code, p.prod_origin, COUNT(DISTINCT o.cust_no) AS num_customers
FROM order_details od
JOIN orders o ON od.order_no = o.order_no
JOIN products p ON od.prod_code = p.prod_code
WHERE EXTRACT(MONTH FROM o.order_date) = 1
  AND EXTRACT(YEAR  FROM o.order_date) = 2024
GROUP BY od.prod_code, p.prod_origin;

-- Q10: Ποια προϊόντα κοστίζουν πιο πολύ για να παραγγελθούν?

SELECT prod_code, description, list_price * reorder_qty AS restock_cost
FROM products
WHERE list_price * reorder_qty = (
    SELECT MAX(list_price * reorder_qty) FROM products
);

-- Q11: Σε ποια ημερομηνία έγινε η πιο μεγάλη παραγγελία που έχει υπάρξει?

SELECT o.order_date
FROM orders o
JOIN order_details od ON o.order_no = od.order_no
GROUP BY o.order_no, o.order_date
ORDER BY SUM(od.order_qty * od.order_price) DESC
LIMIT 1;

-- Q12: Ποια είναι τα ονόματα των πελατών που δεν είχαν καμία παραγγελία τον Φεβρουάριο του 2025;

SELECT cust_name
FROM customers
WHERE cust_no NOT IN (
    SELECT cust_no
    FROM orders
    WHERE EXTRACT(MONTH FROM order_date) = 2
      AND EXTRACT(YEAR  FROM order_date) = 2025
);

-- Q13: Βρείτε όλα τα ονόματα των πελατών που έχουν κάνει παραγγελίες την 12η Αυγούστου 2025.

SELECT DISTINCT c.cust_name
FROM customers c
JOIN orders o ON c.cust_no = o.cust_no
WHERE o.order_date = '2025-08-12';

-- Q14: Ποιο είναι το prod_origin αντιπροσωπεύει το μεγαλύτερο ποσοστό της συνολικής αξίας των διαθέσιμων αποθεμάτων;

SELECT prod_origin
FROM products
GROUP BY prod_origin
HAVING SUM(qty_on_hand * list_price) = (
    SELECT MAX(origin_total)
    FROM (
        SELECT SUM(qty_on_hand * list_price) AS origin_total
        FROM products
        GROUP BY prod_origin
    ) AS sub
);

-- Q15: Αναφέρετε τον κωδικό προϊόντος και την περιγραφή των προϊόντων που έχουν πωληθεί κάποια στιγμή κάτω από την τιμή καταλόγου.

SELECT DISTINCT p.prod_code, p.description
FROM products p
JOIN order_details od ON p.prod_code = od.prod_code
WHERE od.order_price < p.list_price;

-- Q16: Βρείτε παραγγελίες για τις οποίες δεν υπάρχει αντίστοιχος πελάτης.

SELECT *
FROM orders
WHERE cust_no NOT IN (SELECT cust_no FROM customers);

-- Q17: Παρουσιάστε πελάτες που δεν έχουν ποτέ παραγγείλει.

SELECT cust_name
FROM customers
WHERE cust_no NOT IN (
    SELECT cust_no FROM orders WHERE cust_no IS NOT NULL
);

-- Q18: Βρείτε τον κωδικό προϊόντος και την περιγραφή όλων των προϊόντων που είτε
-- παραγγέλθηκαν τον Απρίλιο του 2024 είτε παραγγέλθηκαν τουλάχιστον δύο φορές τον
-- Μάιο του 2025.

SELECT p.prod_code, p.description
FROM products p
WHERE p.prod_code IN (
    SELECT od.prod_code
    FROM order_details od
    JOIN orders o ON od.order_no = o.order_no
    WHERE EXTRACT(MONTH FROM o.order_date) = 4
      AND EXTRACT(YEAR  FROM o.order_date) = 2024
)
UNION
SELECT p.prod_code, p.description
FROM products p
WHERE p.prod_code IN (
    SELECT od.prod_code
    FROM order_details od
    JOIN orders o ON od.order_no = o.order_no
    WHERE EXTRACT(MONTH FROM o.order_date) = 5
      AND EXTRACT(YEAR  FROM o.order_date) = 2025
    GROUP BY od.prod_code
    HAVING COUNT(DISTINCT o.order_no) >= 2
);

-- Q19: Αναφέρετε τις περιγραφές προϊόντων και τα ονόματα πελατών για όλες τις παραγγελίες που πραγματοποιούνται από πελάτες στην Ξάνθη.

SELECT p.description, c.cust_name
FROM customers c
JOIN orders o ON c.cust_no = o.cust_no
JOIN order_details od ON o.order_no = od.order_no
JOIN products p ON od.prod_code = p.prod_code
WHERE c.town = 'Ξάνθη';

-- Q20: Ποιο είναι το μέγιστο ποσό κατά το οποίο ένας πελάτης υπερβαίνει το πιστωτικό του όριο;

SELECT MAX(curr_balance - cr_limit) AS max_exceeded
FROM customers
WHERE curr_balance > cr_limit;
