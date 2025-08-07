
-- FILE 2: DDL (ALTER, DROP, RENAME) + AGGREGATE + MATH/STRING/DATE FUNCTIONS

-- DDL: Add a new column to Products
ALTER TABLE Products ADD COLUMN warranty_years INT DEFAULT 1;

-- DDL: Rename column
ALTER TABLE Products RENAME COLUMN warranty_years TO warranty;

-- DDL: Drop a column
ALTER TABLE Products DROP COLUMN warranty;

-- Aggregate Functions
SELECT COUNT(*) AS total_customers FROM Customers;
SELECT AVG(price) AS average_product_price FROM Products;
SELECT SUM(total_amount) AS total_sales FROM Orders;

-- Math Functions
SELECT ABS(-10), CEIL(10.2), FLOOR(10.8), ROUND(15.678, 2);

-- String Functions
SELECT UPPER(name), LOWER(email), LENGTH(address) FROM Customers;

-- Date Functions
SELECT CURRENT_DATE(), CURRENT_TIME(), NOW();
SELECT order_id, DATEDIFF(NOW(), order_date) AS days_since_order FROM Orders;
