-- create database project;
use project;
-- DROP all existing tables if any (optional clean-up)
DROP TABLE IF EXISTS StockLog, OrderItems, Payments, Orders, Products, Customers, Staff;

-- 1. Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT
);

-- 2. Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0)
);

-- 3. Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 4. OrderItems Table
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 5. Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount_paid DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50) DEFAULT 'Completed',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- 6. Staff Table
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    role VARCHAR(50),
    password VARCHAR(255)
);

-- 7. View: Order Summary
CREATE VIEW OrderSummary AS
SELECT 
    o.order_id,
    c.name AS customer_name,
    o.order_date,
    o.total_amount,
    o.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- 8. Function: Calculate Tax
DELIMITER $$
CREATE FUNCTION CalculateTax(subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN subtotal * 0.18;
END $$
DELIMITER ;

-- 9. Stored Procedure: Place Order
DELIMITER $$
CREATE PROCEDURE PlaceOrder (
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);

    -- Get product price
    SELECT price INTO v_price FROM Products WHERE product_id = p_product_id;

    -- Calculate total
    SET v_total = v_price * p_quantity;

    -- Start transaction
    START TRANSACTION;

    -- Create order
    INSERT INTO Orders(customer_id, total_amount) VALUES (p_customer_id, v_total);

    -- Get last inserted order ID
    SET @last_order_id = LAST_INSERT_ID();

    -- Insert into OrderItems
    INSERT INTO OrderItems(order_id, product_id, quantity, price)
    VALUES (@last_order_id, p_product_id, p_quantity, v_price);

    -- Update stock
    UPDATE Products
    SET stock_quantity = stock_quantity - p_quantity
    WHERE product_id = p_product_id;

    -- Commit
    COMMIT;
END $$
DELIMITER ;

-- 10. StockLog Table for Trigger
CREATE TABLE StockLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    old_stock INT,
    new_stock INT,
    change_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 11. Trigger: Log Stock Changes
DELIMITER $$
CREATE TRIGGER after_stock_update
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.stock_quantity != NEW.stock_quantity THEN
        INSERT INTO StockLog(product_id, old_stock, new_stock)
        VALUES (OLD.product_id, OLD.stock_quantity, NEW.stock_quantity);
    END IF;
END $$
DELIMITER ;

-- 12. Index for Search Optimization
CREATE INDEX idx_product_name ON Products(name);

-- 13. Join Query Example (optional usage)
-- Get full order details with customer and product
-- (This is not part of schema, just example query)
-- 
-- SELECT o.order_id, c.name AS customer_name, p.name AS product_name,
--        oi.quantity, oi.price
-- FROM Orders o
-- JOIN Customers c ON o.customer_id = c.customer_id
-- JOIN OrderItems oi ON o.order_id = oi.order_id
-- JOIN Products p ON oi.product_id = p.product_id;

-- 14. CASE Statement Usage Example (optional usage)
-- SELECT payment_id, amount_paid, payment_status,
--        CASE 
--            WHEN payment_status = 'Completed' THEN '✅ Paid'
--            WHEN payment_status = 'Pending' THEN '⚠️ Pending'
--            ELSE '❌ Failed'
--        END AS status_note
-- FROM Payments;
