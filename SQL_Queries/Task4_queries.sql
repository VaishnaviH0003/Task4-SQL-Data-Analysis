-- =======================================================
-- Internship Task: SQL for Data Analysis
-- Database: ecommerce_db
-- Tool: MySQL Command Line Client
-- =======================================================

-- STEP 1: Create and use database
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- STEP 2: Create Tables
-- Customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50)
);

-- Products table
CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- STEP 3: Insert Sample Data
INSERT INTO customers VALUES 
(1, 'Alice', 'Delhi'),
(2, 'Bob', 'Mumbai'),
(3, 'Charlie', 'Chennai'),
(4, 'Daisy', 'Kolkata');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 75000),
(102, 'Phone', 'Electronics', 30000),
(103, 'Shoes', 'Fashion', 2500),
(104, 'Watch', 'Fashion', 5000);

INSERT INTO orders VALUES
(1001, 1, '2025-01-15', 105000),
(1002, 2, '2025-02-20', 30000),
(1003, 1, '2025-03-05', 2500),
(1004, 3, '2025-04-10', 8000);

INSERT INTO order_items VALUES
(1001, 101, 1),
(1001, 102, 1),
(1002, 102, 1),
(1003, 103, 1),
(1004, 104, 2);

-- =======================================================
-- QUERIES FOR TASK
-- =======================================================

-- Q1: SELECT + WHERE example → List customers from Delhi
SELECT * FROM customers WHERE city = 'Delhi';

-- Q2: GROUP BY + ORDER BY → Total revenue per customer
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- Q3: INNER JOIN → Orders with customer names
SELECT o.order_id, c.name, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Q4: LEFT JOIN → All customers, even without orders
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Q5: RIGHT JOIN → All orders, even if no customer info
SELECT c.name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- Q6: Aggregate Functions → Average and Total revenue
SELECT AVG(total_amount) AS avg_order_amount, 
       SUM(total_amount) AS total_revenue
FROM orders;

-- Q7: Subquery → Customers who spent more than 50000
SELECT name 
FROM customers 
WHERE customer_id IN (
    SELECT customer_id 
    FROM orders 
    GROUP BY customer_id 
    HAVING SUM(total_amount) > 50000
);

-- Q8: Monthly Revenue Trend
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, 
       SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY month
ORDER BY month;

-- Q9: Create a VIEW → High-value orders (above 50,000)
CREATE VIEW high_value_orders AS
SELECT * FROM orders WHERE total_amount > 50000;

-- Q10: Query the View
SELECT * FROM high_value_orders;

-- Q11: Create another VIEW → Repeat customers (more than 1 order)
CREATE VIEW repeat_customers AS
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING total_orders > 1;

-- Q12: Query the Repeat Customers View
SELECT * FROM repeat_customers;

-- Done ✅
-- =======================================================
