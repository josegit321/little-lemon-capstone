-- Little Lemon reporting queries, prepared statement and booking procedures

USE LittleLemonDB;

CREATE OR REPLACE VIEW OrdersView AS
SELECT
    o.OrderID,
    o.CustomerID,
    c.FullName,
    SUM(oi.Quantity) AS TotalQuantity,
    o.TotalAmount AS Cost,
    o.OrderDate,
    o.Status
FROM Orders AS o
INNER JOIN Customers AS c
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderItems AS oi
    ON oi.OrderID = o.OrderID
GROUP BY
    o.OrderID,
    o.CustomerID,
    c.FullName,
    o.TotalAmount,
    o.OrderDate,
    o.Status;

-- Orders with a total above 50, including their ordered menu items.
SELECT
    c.CustomerID,
    c.FullName,
    o.OrderID,
    o.TotalAmount AS Cost,
    mi.Name AS MenuItem,
    mi.Category,
    oi.Quantity
FROM Customers AS c
INNER JOIN Orders AS o
    ON o.CustomerID = c.CustomerID
INNER JOIN OrderItems AS oi
    ON oi.OrderID = o.OrderID
INNER JOIN MenuItems AS mi
    ON mi.MenuItemID = oi.MenuItemID
WHERE o.TotalAmount > 50
ORDER BY o.TotalAmount DESC, o.OrderID, mi.Name;

-- Menu items ordered more than twice across all orders.
SELECT
    mi.MenuItemID,
    mi.Name,
    SUM(oi.Quantity) AS QuantityOrdered
FROM MenuItems AS mi
INNER JOIN OrderItems AS oi
    ON oi.MenuItemID = mi.MenuItemID
GROUP BY mi.MenuItemID, mi.Name
HAVING SUM(oi.Quantity) > 2
ORDER BY QuantityOrdered DESC, mi.Name;

-- Prepared statement for retrieving a customer's order details.
PREPARE GetOrderDetail FROM
    'SELECT o.OrderID, SUM(oi.Quantity) AS Quantity, o.TotalAmount AS Cost
       FROM Orders AS o
       INNER JOIN OrderItems AS oi ON oi.OrderID = o.OrderID
      WHERE o.CustomerID = ?
      GROUP BY o.OrderID, o.TotalAmount
      ORDER BY o.OrderID';

SET @CustomerID = 1;
EXECUTE GetOrderDetail USING @CustomerID;
DEALLOCATE PREPARE GetOrderDetail;

DELIMITER //

DROP PROCEDURE IF EXISTS GetMaxQuantity //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT COALESCE(MAX(Quantity), 0) AS MaxQuantity
    FROM OrderItems;
END //

DROP PROCEDURE IF EXISTS ManageBooking //
CREATE PROCEDURE ManageBooking(
    IN p_booking_date DATE,
    IN p_table_number INT
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Bookings
        WHERE BookingDate = p_booking_date
          AND TableNumber = p_table_number
    ) THEN
        SELECT CONCAT(
            'Table ', p_table_number,
            ' is already booked on ', DATE_FORMAT(p_booking_date, '%Y-%m-%d'), '.'
        ) AS BookingStatus;
    ELSE
        SELECT CONCAT(
            'Table ', p_table_number,
            ' is available on ', DATE_FORMAT(p_booking_date, '%Y-%m-%d'), '.'
        ) AS BookingStatus;
    END IF;
END //

DROP PROCEDURE IF EXISTS UpdateBooking //
CREATE PROCEDURE UpdateBooking(
    IN p_booking_id INT,
    IN p_new_booking_date DATE
)
main: BEGIN
    DECLARE v_table_number INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SELECT TableNumber
      INTO v_table_number
      FROM Bookings
     WHERE BookingID = p_booking_id;

    IF v_table_number IS NULL THEN
        SELECT CONCAT('Booking ', p_booking_id, ' does not exist.') AS Confirmation;
        LEAVE main;
    END IF;

    IF EXISTS (
        SELECT 1
          FROM Bookings
         WHERE BookingDate = p_new_booking_date
           AND TableNumber = v_table_number
           AND BookingID <> p_booking_id
    ) THEN
        SELECT CONCAT(
            'Table ', v_table_number,
            ' is already booked on ', DATE_FORMAT(p_new_booking_date, '%Y-%m-%d'), '.'
        ) AS Confirmation;
        LEAVE main;
    END IF;

    START TRANSACTION;
    UPDATE Bookings
       SET BookingDate = p_new_booking_date
     WHERE BookingID = p_booking_id;
    COMMIT;

    SELECT CONCAT(
        'Booking ', p_booking_id,
        ' updated to ', DATE_FORMAT(p_new_booking_date, '%Y-%m-%d'), '.'
    ) AS Confirmation;
END //

DROP PROCEDURE IF EXISTS AddBooking //
CREATE PROCEDURE AddBooking(
    IN p_booking_id INT,
    IN p_customer_id INT,
    IN p_booking_date DATE,
    IN p_table_number INT
)
main: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1
          FROM Customers
         WHERE CustomerID = p_customer_id
    ) THEN
        SELECT CONCAT('Customer ', p_customer_id, ' does not exist.') AS Confirmation;
        LEAVE main;
    END IF;

    IF EXISTS (
        SELECT 1
          FROM Bookings
         WHERE BookingID = p_booking_id
    ) THEN
        SELECT CONCAT('Booking ', p_booking_id, ' already exists.') AS Confirmation;
        LEAVE main;
    END IF;

    IF EXISTS (
        SELECT 1
          FROM Bookings
         WHERE BookingDate = p_booking_date
           AND TableNumber = p_table_number
    ) THEN
        SELECT CONCAT(
            'Table ', p_table_number,
            ' is already booked on ', DATE_FORMAT(p_booking_date, '%Y-%m-%d'), '.'
        ) AS Confirmation;
        LEAVE main;
    END IF;

    START TRANSACTION;
    INSERT INTO Bookings (
        BookingID,
        CustomerID,
        BookingDate,
        BookingTime,
        TableNumber,
        NumberOfGuests
    ) VALUES (
        p_booking_id,
        p_customer_id,
        p_booking_date,
        '18:00:00',
        p_table_number,
        1
    );
    COMMIT;

    SELECT CONCAT('Booking ', p_booking_id, ' added successfully.') AS Confirmation;
END //

DROP PROCEDURE IF EXISTS CancelBooking //
CREATE PROCEDURE CancelBooking(IN p_booking_id INT)
main: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1
          FROM Bookings
         WHERE BookingID = p_booking_id
    ) THEN
        SELECT CONCAT('Booking ', p_booking_id, ' does not exist.') AS Confirmation;
        LEAVE main;
    END IF;

    START TRANSACTION;
    DELETE FROM Bookings
     WHERE BookingID = p_booking_id;
    COMMIT;

    SELECT CONCAT('Booking ', p_booking_id, ' cancelled successfully.') AS Confirmation;
END //

DELIMITER ;

-- Procedure checks. Run these individually after creating the schema.
CALL GetMaxQuantity();
CALL ManageBooking('2026-10-10', 5);
CALL ManageBooking('2026-10-13', 5);
CALL UpdateBooking(3, '2026-10-14');
CALL AddBooking(4, 4, '2026-10-15', 4);
CALL CancelBooking(4);
