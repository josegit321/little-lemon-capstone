"""Learning scaffold for the Little Lemon MySQL client.

Complete the TODOs yourself and test each function against your schema.
Never commit real credentials.
"""

from __future__ import annotations

import os
from contextlib import contextmanager

import mysql.connector
from mysql.connector import Error


def connection_config() -> dict[str, object]:
    """Load connection values from environment variables."""
    return {
        "host": os.getenv("MYSQL_HOST", "localhost"),
        "port": int(os.getenv("MYSQL_PORT", "3306")),
        "user": os.getenv("MYSQL_USER", ""),
        "password": os.getenv("MYSQL_PASSWORD", ""),
        "database": os.getenv("MYSQL_DATABASE", "LittleLemonDB"),
    }


@contextmanager
def database_connection():
    """Open a MySQL connection and always close it."""
    connection = None
    try:
        connection = mysql.connector.connect(**connection_config())
        yield connection
    finally:
        if connection is not None and connection.is_connected():
            connection.close()


def show_tables() -> list[str]:
    """Return table names; useful for checking the connection."""
    with database_connection() as connection:
        cursor = connection.cursor()
        try:
            cursor.execute("SHOW TABLES")
            return [row[0] for row in cursor.fetchall()]
        finally:
            cursor.close()


def call_booking_procedure(procedure_name: str, args: tuple[object, ...]):
    """TODO: safely call only the procedures you explicitly allow."""
    allowed = {
        "GetMaxQuantity",
        "ManageBooking",
        "UpdateBooking",
        "AddBooking",
        "CancelBooking",
    }
    if procedure_name not in allowed:
        raise ValueError("Unsupported procedure")

    # TODO: Open a connection, call the selected procedure, collect all
    # result sets, commit changes when appropriate, and handle Error.
    raise NotImplementedError("Implement and test the procedure call")


if __name__ == "__main__":
    try:
        print(show_tables())
    except Error as exc:
        print(f"Database connection failed: {exc}")
