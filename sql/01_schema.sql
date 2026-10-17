-- Little Lemon database schema
-- Re-runnable setup for the capstone project.

CREATE DATABASE IF NOT EXISTS LittleLemonDB
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE LittleLemonDB;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS MenuItems;
DROP TABLE IF EXISTS Customers;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Customers (
    CustomerID INT NOT NULL AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    ContactNumber VARCHAR(30) NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (CustomerID),
    CONSTRAINT uq_customers_email UNIQUE (Email)
) ENGINE = InnoDB;

CREATE TABLE MenuItems (
    MenuItemID INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Description VARCHAR(255) NULL,
    CONSTRAINT pk_menu_items PRIMARY KEY (MenuItemID),
    CONSTRAINT chk_menu_item_price CHECK (Price >= 0)
) ENGINE = InnoDB;

CREATE TABLE Bookings (
    BookingID INT NOT NULL AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    BookingDate DATE NOT NULL,
    BookingTime TIME NOT NULL DEFAULT '18:00:00',
    TableNumber INT NOT NULL,
    NumberOfGuests INT NOT NULL DEFAULT 1,
    CONSTRAINT pk_bookings PRIMARY KEY (BookingID),
    CONSTRAINT uq_bookings_table_date UNIQUE (BookingDate, TableNumber),
    CONSTRAINT chk_booking_table CHECK (TableNumber > 0),
    CONSTRAINT chk_booking_guests CHECK (NumberOfGuests > 0),
    CONSTRAINT fk_bookings_customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers (CustomerID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE Orders (
    OrderID INT NOT NULL AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    Status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    CONSTRAINT pk_orders PRIMARY KEY (OrderID),
    CONSTRAINT chk_order_total CHECK (TotalAmount >= 0),
    CONSTRAINT fk_orders_customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers (CustomerID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE OrderItems (
    OrderItemID INT NOT NULL AUTO_INCREMENT,
    OrderID INT NOT NULL,
    MenuItemID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_order_items PRIMARY KEY (OrderItemID),
    CONSTRAINT uq_order_menu_item UNIQUE (OrderID, MenuItemID),
    CONSTRAINT chk_order_item_quantity CHECK (Quantity > 0),
    CONSTRAINT chk_order_item_price CHECK (UnitPrice >= 0),
    CONSTRAINT fk_order_items_orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders (OrderID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_menu_items
        FOREIGN KEY (MenuItemID)
        REFERENCES MenuItems (MenuItemID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE INDEX idx_bookings_customer ON Bookings (CustomerID);
CREATE INDEX idx_orders_customer_date ON Orders (CustomerID, OrderDate);
CREATE INDEX idx_menu_items_category ON MenuItems (Category);

-- Small synthetic data set used only to verify the schema and procedures.
INSERT INTO Customers (CustomerID, FullName, Email, ContactNumber) VALUES
    (1, 'Anna Iversen', 'anna.iversen@example.com', '+1-202-555-0101'),
    (2, 'Joakim Iversen', 'joakim.iversen@example.com', '+1-202-555-0102'),
    (3, 'Vanessa McCarthy', 'vanessa.mccarthy@example.com', '+1-202-555-0103'),
    (4, 'Marcos Romero', 'marcos.romero@example.com', '+1-202-555-0104'),
    (99, 'Peer Review Test Customer', 'peer.review@example.com', '+1-202-555-0199');

INSERT INTO MenuItems (MenuItemID, Name, Category, Price, Description) VALUES
    (1, 'Greek Salad', 'Starter', 12.50, 'Tomatoes, cucumber, olives and feta'),
    (2, 'Bruschetta', 'Starter', 8.50, 'Grilled bread with tomato and basil'),
    (3, 'Grilled Fish', 'Main Course', 24.00, 'Seasonal fish with lemon herbs'),
    (4, 'Pasta Primavera', 'Main Course', 19.50, 'Pasta with seasonal vegetables'),
    (5, 'Lemon Dessert', 'Dessert', 9.00, 'House lemon dessert');

INSERT INTO Bookings
    (BookingID, CustomerID, BookingDate, BookingTime, TableNumber, NumberOfGuests)
VALUES
    (1, 1, '2026-10-10', '18:00:00', 5, 2),
    (2, 2, '2026-10-11', '19:00:00', 3, 4),
    (3, 3, '2026-10-12', '17:30:00', 2, 2);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status) VALUES
    (1, 1, '2026-10-10 18:15:00', 95.50, 'Delivered'),
    (2, 2, '2026-10-11 19:20:00', 73.50, 'Delivered'),
    (3, 3, '2026-10-12 17:45:00', 36.00, 'Preparing');

INSERT INTO OrderItems (OrderItemID, OrderID, MenuItemID, Quantity, UnitPrice) VALUES
    (1, 1, 1, 5, 12.50),
    (2, 1, 3, 1, 24.00),
    (3, 1, 5, 1, 9.00),
    (4, 2, 2, 3, 8.50),
    (5, 2, 3, 2, 24.00),
    (6, 3, 1, 1, 12.50),
    (7, 3, 4, 1, 19.50);

-- Basic verification queries.
SHOW TABLES;
SELECT 'Customers' AS TableName, COUNT(*) AS RowCount FROM Customers
UNION ALL
SELECT 'Bookings', COUNT(*) FROM Bookings
UNION ALL
SELECT 'MenuItems', COUNT(*) FROM MenuItems
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM OrderItems;
