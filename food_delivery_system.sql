create database tomato;
use tomato;
create table Users(
	user_id int auto_increment primary key,
	name varchar(225) not null,
	email varchar(225) unique not null,
	phone varchar(15) unique not null,
	address text not null,
	user_password VARCHAR(255) NOT NULL,  -- Hashed password for security
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    restraunt_name VARCHAR(100) NOT NULL,
    restraunt_address TEXT NOT NULL,
    cuisine_type VARCHAR(50) NOT NULL,
    rating FLOAT DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    open_time TIME NOT NULL,
    close_time TIME NOT NULL
);

CREATE TABLE Menu (
    menu_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    dish_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    availability ENUM('Available', 'Unavailable') DEFAULT 'Available',
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);


CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_status ENUM('Pending', 'Preparing', 'Out for Delivery', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES Menu(menu_id) ON DELETE CASCADE
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method ENUM('Cash', 'Credit Card', 'Debit Card', 'UPI', 'Net Banking') NOT NULL,
    status ENUM('Success', 'Failed', 'Pending') DEFAULT 'Pending',
    transaction_id VARCHAR(50) UNIQUE NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    delivery_person_name VARCHAR(100) NOT NULL,
    delivery_status ENUM('On the way', 'Delivered', 'Cancelled') DEFAULT 'On the way',
    estimated_time VARCHAR(20),
    delivered_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Ratings_Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating FLOAT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE CASCADE
);

CREATE TABLE Admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,  -- Hashed password
    role ENUM('Super Admin', 'Restaurant Admin') DEFAULT 'Restaurant Admin',
    restaurant_id INT NULL,  -- Only for restaurant admins
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id) ON DELETE SET NULL
);

INSERT INTO Users (name, email, phone, address, user_password) 
VALUES 
('Tejas', 'tejas@example.com', '9876543210', 'Ambegaon, Pune', '1234'),
('Arya', 'arya@example.com', '9876543211', 'Ambegaon, Pune', '1234');

INSERT INTO Restaurants (restraunt_name, restraunt_address, cuisine_type, rating, open_time, close_time) 
VALUES 
('Spicy Delight', 'Ambegaon, Pune', 'Indian', 4.5, 11.00, 23.00),
('Pizza House', 'FC Road, Pune', 'Italian', 4.8, 18.00, 02.00);

INSERT INTO Menu (restaurant_id, dish_name, price, availability) 
VALUES 
(1, 'Paneer Butter Masala', 250, 'Available'),
(1, 'Chicken Biryani', 800, 'Available'),
(2, 'Margherita Pizza', 500, 'Available'),
(2, 'Pepperoni Pizza', 600, 'Available');

INSERT INTO Orders (user_id, restaurant_id, order_status, order_date, total_amount) 
VALUES 
(1, 1, 'Pending', NOW(), 550),
(2, 2, 'Preparing', NOW(), 1100);

INSERT INTO Order_Items (order_id, menu_id, quantity) 
VALUES 
(1, 1, 1), 
(1, 2, 1),
(2, 3, 1),
(2, 4, 1);

INSERT INTO Payments (order_id, payment_method, status, transaction_id) 
VALUES 
(1, 'UPI', 'Success', 'TXN123456'),
(2, 'Credit Card', 'Pending', 'TXN789012');

INSERT INTO Delivery (order_id, delivery_person_name, delivery_status, estimated_time) 
VALUES 
(1, 'Rahul Kumar', 'On the way', '30 mins'),
(2, 'Neha Patel', 'On the way', '40 mins');

INSERT INTO Ratings_Reviews (user_id, restaurant_id, rating, review, review_date) 
VALUES 
(1, 1, 4.5, 'Great food and quick delivery!', NOW()),
(2, 2, 5.0, 'Best pizza in town!', NOW());

INSERT INTO Admins (name, email, phone, password, role, restaurant_id) 
VALUES 
('Admin1', 'admin1@example.com', '9876543212', 'adminpassword1', 'Restaurant Admin', 1),
('Super Admin', 'superadmin@example.com', '9876543213', 'adminpassword2', 'Super Admin', NULL);
