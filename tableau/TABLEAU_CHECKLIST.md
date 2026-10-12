# Validación de Tableau

## Preparación de los datos

- [x] Se conservó el archivo oficial `LittleLemon_data.xlsx` sin modificaciones.
- [x] Se documentaron los 42 códigos de país vacíos; no se inventaron valores.
- [x] Se normalizó ` Cost` como `Cost` y `Desert Name` como `Dessert Name` en la copia preparada.
- [x] Se documentó que 21,000 filas representan 1,000 pedidos únicos.
- [x] Se documentaron 9,366 filas con una fecha de entrega anterior a la fecha del pedido.
- [x] Se preparó el subconjunto de Estados Unidos utilizado por las actividades de Tableau.
- [x] Se separó `Customer Name` en `First Name` y `Last Name`.
- [x] Se calculó `Profit` como `Sales - Cost` y `Order Year` a partir de la fecha.
- [x] Tableau reconoció correctamente dimensiones, medidas, fechas y números.

## Hojas solicitadas

- [x] `Customers sales`: barras por cliente y filtro `SUM(Sales) >= 70`.
- [x] `Profit chart`: evolución del beneficio entre 2019 y 2022; 2023 excluido.
- [x] `Sales Bubble Chart`: clientes representados por ventas y beneficio.
- [x] `Cuisine Sales and Profits`: cocinas griega, turca e italiana, años 2020–2022, ordenadas por ventas.
- [x] Títulos, etiquetas y colores legibles.

## Dashboard

- [x] `Little Lemon Sales Dashboard` combina las hojas de ventas por cliente y burbujas.
- [x] `Customers sales` funciona como filtro para `Sales Bubble Chart`.
- [x] La acción se probó seleccionando un cliente y restableciendo la selección.
- [x] Se guardó el workbook editable `.twb`.
- [x] Se exportó el workbook portátil `.twbx` con extracto incrustado.
- [x] Se guardaron capturas PNG en `diagrams/`.

## Preguntas y hallazgos

| Hoja | Pregunta de negocio | Hallazgo reproducible |
|---|---|---|
| Customers sales | ¿Qué clientes generan más ventas? | Sterne Salterne y Petronille Scrimgeour encabezan el subconjunto de EE. UU. con 4,812.30 cada uno. |
| Profit chart | ¿Cómo cambia el beneficio anual? | El máximo del periodo filtrado ocurre en 2021, con 19,780.20. |
| Sales Bubble Chart | ¿Cómo se comparan ventas y beneficio entre clientes? | Permite aislar un cliente desde el dashboard y comparar simultáneamente sus dos métricas. |
| Cuisine Sales and Profits | ¿Qué cocina lidera entre 2020 y 2022? | Greek ocupa el primer lugar con 38,046.16 en ventas y 12,682.06 en beneficio. |

Los valores proceden de `LittleLemon_US_prepared.csv` y pueden verificarse al abrir el workbook empaquetado.
