-- Little Lemon reporting and booking procedures template
USE LittleLemonDB;

-- TODO: Create a reporting view using the JOINs required by your schema.
-- CREATE OR REPLACE VIEW <view_name> AS
-- SELECT ...
-- FROM ...
-- JOIN ...;

DELIMITER //

DROP PROCEDURE IF EXISTS GetMaxQuantity //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    -- TODO: Return the maximum order quantity from your order data.
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TODO: implement GetMaxQuantity';
END //

DROP PROCEDURE IF EXISTS ManageBooking //
CREATE PROCEDURE ManageBooking(
    IN p_booking_date DATE,
    IN p_table_number INT
)
BEGIN
    -- TODO: Check whether the requested booking already exists and
    -- return a clear availability message.
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TODO: implement ManageBooking';
END //

DROP PROCEDURE IF EXISTS UpdateBooking //
CREATE PROCEDURE UpdateBooking(
    IN p_booking_id INT,
    IN p_new_booking_date DATE
)
BEGIN
    -- TODO: Validate the booking, update it atomically and report success.
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TODO: implement UpdateBooking';
END //

DROP PROCEDURE IF EXISTS AddBooking //
CREATE PROCEDURE AddBooking(
    IN p_booking_id INT,
    IN p_customer_id INT,
    IN p_booking_date DATE,
    IN p_table_number INT
)
BEGIN
    -- TODO: Validate availability, insert the booking inside a transaction
    -- and handle duplicate/conflicting reservations.
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TODO: implement AddBooking';
END //

DROP PROCEDURE IF EXISTS CancelBooking //
CREATE PROCEDURE CancelBooking(IN p_booking_id INT)
BEGIN
    -- TODO: Confirm the booking exists, delete it and report the result.
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TODO: implement CancelBooking';
END //

DELIMITER ;

-- TODO: Add CALL statements that demonstrate expected and edge cases.
-- CALL GetMaxQuantity();
-- CALL ManageBooking('2026-10-10', 5);
