# Datos del curso

El archivo oficial `LittleLemon_data.xlsx` se descargó desde la página del proyecto de Coursera y está guardado localmente en esta carpeta. No debe publicarse en el repositorio hasta confirmar que las condiciones del curso permiten redistribuirlo.

## Perfil del archivo original

- Hoja: `Orders`.
- Registros: 21,000.
- Columnas: 21.
- Contiene fechas de pedido y entrega, clientes, ubicación, costos, ventas, cantidad, descuento, costo de entrega y componentes del menú.
- La columna `Country Code` tiene 42 valores vacíos.
- El encabezado ` Cost` contiene un espacio inicial.
- El encabezado `Desert Name` parece referirse a `Dessert Name`; documenta cualquier cambio antes de renombrarlo.
- Hay 1,000 identificadores de pedido únicos dentro de 21,000 filas; no trates cada fila automáticamente como un pedido distinto.
- Hay 1,000 clientes únicos y 123 países.
- En 9,366 filas la fecha de entrega es anterior a la fecha del pedido. Trátalo como un problema de calidad y no lo corrijas inventando fechas.
- Rango de fechas de pedidos: 2019-06-14 a 2023-01-06. Rango de entregas: 2019-10-10 a 2023-01-07.

Antes de usarlo:

- Conserva una copia original sin modificaciones.
- Documenta cualquier limpieza o transformación.
- No inventes resultados que no puedan reproducirse.
- Evita publicar datos sensibles o archivos cuya licencia no permita redistribución.
