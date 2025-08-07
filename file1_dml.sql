
-- FILE 1: DML (Data Manipulation Language)

-- Insert sample data into Customers
INSERT INTO Customers (name, email, phone, address) VALUES
('John Doe', 'john@example.com', '9876543210', '123 Elm Street'),
('Jane Smith', 'jane@example.com', '8765432109', '456 Oak Avenue');

-- Insert sample data into Products
INSERT INTO Products (name, description, price, stock_quantity) VALUES
('Laptop', 'Gaming laptop with RTX 4060', 1200.00, 10),
('Headphones', 'Noise cancelling headphones', 200.00, 30);

-- Insert sample Orders
INSERT INTO Orders (customer_id, total_amount, status) VALUES
(1, 1200.00, 'Completed'),
(2, 200.00, 'Pending');

-- Insert sample OrderItems
INSERT INTO OrderItems (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1200.00),
(2, 2, 1, 200.00);

-- Insert sample Payments
INSERT INTO Payments (order_id, amount_paid, payment_method, payment_status) VALUES
(1, 1200.00, 'Credit Card', 'Completed'),
(2, 200.00, 'UPI', 'Pending');
