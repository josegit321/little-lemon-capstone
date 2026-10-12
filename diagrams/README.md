# Evidencias visuales

## Modelo relacional

[`little_lemon_erd.png`](little_lemon_erd.png) representa el esquema final definido en `../sql/01_schema.sql`:

- `Customers` se relaciona uno a muchos con `Bookings`.
- `Customers` se relaciona uno a muchos con `Orders`.
- `Orders` se relaciona uno a muchos con `OrderItems`.
- `MenuItems` se relaciona uno a muchos con `OrderItems`.
- Se muestran claves primarias, claves foráneas, tipos de datos y cardinalidades.

El modelo editable se encuentra en `../LittleLemonDB_Model.mwb`.

## Tableau

- [`little_lemon_sales_dashboard.png`](little_lemon_sales_dashboard.png): dashboard requerido con ventas por cliente, gráfico de burbujas y acción de filtro.
- [`cuisine_sales_and_profits.png`](cuisine_sales_and_profits.png): ventas y beneficios de las cocinas griega, turca e italiana entre 2020 y 2022.

El workbook portátil se encuentra en `../tableau/LittleLemon_Tableau_Dashboard.twbx`.
