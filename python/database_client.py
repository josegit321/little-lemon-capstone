"""Command-line client for the Little Lemon MySQL database.

Connection details are read from environment variables so credentials are
never committed to the repository.
"""

from __future__ import annotations

import argparse
import os
import warnings
from contextlib import contextmanager
from datetime import date
from decimal import Decimal
from typing import Any, Iterator, Sequence

import mysql.connector
from mysql.connector import Error


ALLOWED_PROCEDURES = {
    "GetMaxQuantity": 0,
    "ManageBooking": 2,
    "UpdateBooking": 2,
    "AddBooking": 4,
    "CancelBooking": 1,
}


def connection_config() -> dict[str, object]:
    """Return a mysql-connector configuration built from the environment."""
    config: dict[str, object] = {
        "user": os.getenv("MYSQL_USER", "root"),
        "password": os.getenv("MYSQL_PASSWORD", ""),
        "database": os.getenv("MYSQL_DATABASE", "LittleLemonDB"),
    }

    unix_socket = os.getenv("MYSQL_UNIX_SOCKET")
    if unix_socket:
        config["unix_socket"] = unix_socket
    else:
        config["host"] = os.getenv("MYSQL_HOST", "127.0.0.1")
        config["port"] = int(os.getenv("MYSQL_PORT", "3306"))

    return config


@contextmanager
def database_connection() -> Iterator[mysql.connector.MySQLConnection]:
    """Open a MySQL connection and close it after the operation finishes."""
    connection = mysql.connector.connect(**connection_config())
    try:
        yield connection
    finally:
        if connection.is_connected():
            connection.close()


def show_tables() -> list[str]:
    """Return all table and view names visible in LittleLemonDB."""
    with database_connection() as connection:
        cursor = connection.cursor()
        try:
            cursor.execute("SHOW FULL TABLES")
            return [str(row[0]) for row in cursor.fetchall()]
        finally:
            cursor.close()


def get_order_details(customer_id: int) -> list[dict[str, Any]]:
    """Return a customer's orders and aggregated quantities."""
    statement = """
        SELECT
            o.OrderID,
            SUM(oi.Quantity) AS Quantity,
            o.TotalAmount AS Cost,
            o.OrderDate,
            o.Status
        FROM Orders AS o
        INNER JOIN OrderItems AS oi
            ON oi.OrderID = o.OrderID
        WHERE o.CustomerID = %s
        GROUP BY
            o.OrderID,
            o.TotalAmount,
            o.OrderDate,
            o.Status
        ORDER BY o.OrderID
    """

    with database_connection() as connection:
        cursor = connection.cursor(dictionary=True)
        try:
            cursor.execute(statement, (customer_id,))
            return list(cursor.fetchall())
        finally:
            cursor.close()


def call_booking_procedure(
    procedure_name: str,
    args: Sequence[object] = (),
) -> list[list[dict[str, Any]]]:
    """Call one approved stored procedure and return all of its result sets."""
    expected_args = ALLOWED_PROCEDURES.get(procedure_name)
    if expected_args is None:
        raise ValueError(f"Unsupported procedure: {procedure_name}")
    if len(args) != expected_args:
        raise ValueError(
            f"{procedure_name} expects {expected_args} argument(s); got {len(args)}"
        )

    with database_connection() as connection:
        cursor = connection.cursor(dictionary=True)
        try:
            cursor.callproc(procedure_name, tuple(args))
            # mysql-connector 9.4 warns that this method will become a property;
            # keeping the warning out of the user-facing CLI makes test output clear.
            with warnings.catch_warnings():
                warnings.simplefilter("ignore", DeprecationWarning)
                stored_results = cursor.stored_results()
            result_sets = [list(result.fetchall()) for result in stored_results]
            if procedure_name in {"UpdateBooking", "AddBooking", "CancelBooking"}:
                connection.commit()
            return result_sets
        except Error:
            connection.rollback()
            raise
        finally:
            cursor.close()


def _coerce_argument(value: str) -> object:
    """Convert command-line values to simple MySQL-friendly Python values."""
    if value.isdigit() or (value.startswith("-") and value[1:].isdigit()):
        return int(value)
    try:
        return date.fromisoformat(value)
    except ValueError:
        return value


def _print_rows(rows: Sequence[dict[str, Any]]) -> None:
    if not rows:
        print("No rows returned.")
        return

    columns = list(rows[0].keys())
    print("\t".join(columns))
    for row in rows:
        formatted = []
        for column in columns:
            value = row[column]
            if isinstance(value, Decimal):
                formatted.append(format(value, "f"))
            else:
                formatted.append(str(value))
        print("\t".join(formatted))


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Little Lemon database client")
    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("tables", help="List tables and views")

    orders_parser = subparsers.add_parser(
        "orders", help="Show order details for one customer"
    )
    orders_parser.add_argument("customer_id", type=int)

    call_parser = subparsers.add_parser(
        "call", help="Call an approved booking procedure"
    )
    call_parser.add_argument("procedure", choices=sorted(ALLOWED_PROCEDURES))
    call_parser.add_argument("arguments", nargs="*")

    return parser


def main() -> int:
    args = build_parser().parse_args()

    try:
        if args.command == "tables":
            for table_name in show_tables():
                print(table_name)
        elif args.command == "orders":
            _print_rows(get_order_details(args.customer_id))
        else:
            procedure_args = tuple(_coerce_argument(value) for value in args.arguments)
            for result_set in call_booking_procedure(args.procedure, procedure_args):
                _print_rows(result_set)
    except (Error, ValueError) as exc:
        print(f"Little Lemon operation failed: {exc}")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
