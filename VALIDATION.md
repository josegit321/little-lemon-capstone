# Resultados de validación

Fecha de validación: 11 de octubre de 2026.

## MySQL

- `01_schema.sql` se ejecutó desde una base limpia en una instancia temporal de MySQL 8.
- Se crearon las cinco tablas y sus cuatro relaciones sin errores.
- Los datos sintéticos se cargaron correctamente.
- `02_queries_and_procedures.sql` creó `OrdersView`, ejecutó las consultas y preparó `GetOrderDetail`.
- Se crearon y ejecutaron correctamente `GetMaxQuantity`, `ManageBooking`, `UpdateBooking`, `AddBooking` y `CancelBooking`.

## Python

- `database_client.py` se probó contra la instancia temporal.
- La enumeración de tablas, la consulta de pedidos y las llamadas permitidas a procedimientos devolvieron resultados.
- La configuración usa variables de entorno; no hay contraseñas incrustadas.

## Tableau

- El workbook contiene exactamente las cuatro hojas solicitadas y el dashboard final.
- Los filtros de años y cocinas se guardaron en las hojas correspondientes.
- La acción de filtro parte de `Customers sales` y actualiza `Sales Bubble Chart`.
- La acción se probó seleccionando un cliente y después restableciendo el panel.
- El archivo `.twbx` contiene el workbook y un extracto de datos incrustado.

## Archivos y seguridad

- El modelo `.mwb`, los dos scripts SQL, el cliente Python, el workbook `.twbx` y las evidencias PNG están presentes.
- El archivo oficial de Coursera se conserva localmente y está excluido de Git.
- `.env`, respaldos y archivos temporales están excluidos de Git.
- Antes de publicar se ejecuta una última búsqueda de secretos y una revisión del contenido que Git incluirá.
