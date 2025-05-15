CREATE DATABASE CrunchandMunchCerealsShop;

USE CrunchandMunchCerealsShop;

CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- EMPLOYEES TABLE
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role_id INT,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- CATEGORIES TABLE
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- SUPPLIERS TABLE
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

-- ADDRESSES TABLE
CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) DEFAULT 'Kenya'
);

-- SUPPLIER ADDRESSES
ALTER TABLE suppliers ADD address_id INT, ADD FOREIGN KEY (address_id) REFERENCES addresses(address_id);

-- CUSTOMERS TABLE
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);

-- CEREALS TABLE
CREATE TABLE cereals (
    cereal_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    supplier_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- INVENTORY TABLE
CREATE TABLE inventory (
    cereal_id INT PRIMARY KEY,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cereal_id) REFERENCES cereals(cereal_id)
);

-- ORDERS TABLE
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    employee_id INT,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- ORDER ITEMS TABLE
CREATE TABLE order_items (
    order_id INT,
    cereal_id INT,
    quantity INT NOT NULL,
    price_each DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, cereal_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (cereal_id) REFERENCES cereals(cereal_id)
);

-- PAYMENT METHODS TABLE
CREATE TABLE payment_methods (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL UNIQUE
);

-- PAYMENTS TABLE
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid DECIMAL(10, 2) NOT NULL,
    method_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (method_id) REFERENCES payment_methods(method_id)
);

-- DELIVERY STATUS TABLE
CREATE TABLE delivery_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

-- SHIPPING TABLE
CREATE TABLE shipping (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    shipped_date DATE,
    delivery_address_id INT NOT NULL,
    status_id INT DEFAULT 1,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (delivery_address_id) REFERENCES addresses(address_id),
    FOREIGN KEY (status_id) REFERENCES delivery_status(status_id)
);

-- Example of the data 

-- ROLES
INSERT INTO roles (role_name) VALUES ('Sales Manager'), ('Warehouse Clerk');

-- EMPLOYEES
INSERT INTO employees (name, role_id, email, phone)
VALUES 
('Alice Mwangi', 1, 'alice@cerealsite.com', '0799999999'),
('Brian Otieno', 2, 'brian@cerealsite.com', '0788888888');

-- ADDRESSES
INSERT INTO addresses (street, city) 
VALUES 
('Stall 12', 'Eldoret'), ( 'Stall 8', 'Nakuru'), 
('Plot 45', 'Kisumu'), ('House 10', 'Nairobi');

-- SUPPLIERS
INSERT INTO suppliers (name, contact_email, phone, address_id)
VALUES 
('AgroSupplies Ltd', 'agrosupplies.com', '0711000000', 1),
('FarmFresh Distributors', 'info@farmfresh.com', '0722000001', 2);

-- CUSTOMERS
INSERT INTO customers (name, email, phone, address_id)
VALUES 
('John Doe', 'john.doe@example.com', '0700000000', 3),
('Grace Wanjiku', 'grace.wanjiku@example.com', '0711111111', 4);

-- CATEGORIES
INSERT INTO categories (name) VALUES ('Maize'), ('Sorghum'), ('Millet');

-- CEREALS
INSERT INTO cereals (name, description, price, category_id, supplier_id)
VALUES 
('Maize Flour', 'Refined white maize flour for ugali', 150.00, 1, 1),
('Brown Sorghum', 'Whole grain sorghum for porridge', 180.00, 2, 2),
('Pearl Millet', 'Cleaned and packed pearl millet', 200.00, 3, 2);

-- INVENTORY
INSERT INTO inventory (cereal_id, quantity_in_stock)
VALUES 
(1, 500),
(2, 300),
(3, 250);

-- ORDERS
INSERT INTO orders (customer_id, employee_id, order_date)
VALUES 
(1, 1, '2025-05-10'),
(2, 1, '2025-05-11');

-- ORDER ITEMS
INSERT INTO order_items (order_id, cereal_id, quantity, price_each)
VALUES 
(1, 1, 1, 150.00),
(1, 2, 1, 180.00),
(2, 3, 1, 200.00);

-- PAYMENT METHODS
INSERT INTO payment_methods (method_name)
VALUES ('Cash'), ('Card'), ('Mobile Money'), ('Bank Transfer');

-- PAYMENTS
INSERT INTO payments (order_id, payment_date, amount_paid, method_id)
VALUES 
(1, '2025-05-10', 330.00, 3),
(2, '2025-05-11', 200.00, 2);

-- DELIVERY STATUS
INSERT INTO delivery_status (status_name)
VALUES ('Pending'), ('Shipped'), ('Delivered'), ('Cancelled');

-- SHIPPING
INSERT INTO shipping (order_id, shipped_date, delivery_address_id, status_id)
VALUES 
(1, '2025-05-12', 3, 3),
(2, NULL, 4, 1);