
-- FILE 3: JOINs + Stored Procedure + Trigger

-- JOIN: Get order details with customer and product names
SELECT o.order_id, c.name AS customer_name, p.name AS product_name,
       oi.quantity, oi.price
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id;

-- Stored Procedure: Get all orders by customer ID
DELIMITER $$
CREATE PROCEDURE GetCustomerOrders(IN cid INT)
BEGIN
    SELECT * FROM Orders WHERE customer_id = cid;
END $$
DELIMITER ;

-- Trigger: Log price changes in Products
CREATE TABLE PriceLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER price_change_trigger
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.price != NEW.price THEN
        INSERT INTO PriceLog(product_id, old_price, new_price)
        VALUES (OLD.product_id, OLD.price, NEW.price);
    END IF;
END $$
DELIMITER ;
