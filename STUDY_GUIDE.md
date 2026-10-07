# Guía de estudio — módulos 2 y 3

Esta guía resume conceptos. No contiene respuestas de quizzes.

## Módulo 2: consultas, procedimientos y prepared statements

### Vistas y JOINs

- Diferencia entre `INNER JOIN`, `LEFT JOIN` y `RIGHT JOIN`.
- Cuándo usar una vista para presentar un reporte sin duplicar datos.
- Cómo elegir claves de unión correctas y evitar productos cartesianos.
- Agregaciones con `COUNT`, `SUM`, `AVG`, `MAX`, `GROUP BY` y `HAVING`.

### Procedimientos almacenados

- Parámetros `IN`, `OUT` e `INOUT`.
- Uso de `DELIMITER` al crear procedimientos en MySQL.
- Validación de entradas antes de insertar o actualizar.
- Manejo de errores con `SIGNAL SQLSTATE`.
- Diferencia entre procedimiento, función y consulta preparada.

### Transacciones

- `START TRANSACTION`, `COMMIT` y `ROLLBACK`.
- Por qué una reserva debe validarse y modificarse de forma atómica.
- Riesgo de doble reserva y cómo mitigarlo con restricciones y transacciones.

### Prepared statements

- Separar el texto SQL de los valores introducidos por el usuario.
- Beneficios: seguridad, reutilización y claridad.
- Nunca concatenar directamente entradas del usuario en SQL.

## Módulo 3: cliente Python y visualización

### Cliente Python/MySQL

- Abrir y cerrar conexiones y cursores correctamente.
- Usar parámetros `%s` con `mysql.connector`.
- Confirmar cambios con `commit()` y revertir con `rollback()`.
- Capturar excepciones específicas y no revelar credenciales.
- Leer configuración desde variables de entorno.

### Tableau

- Conectar la fuente de datos y revisar tipos de campo.
- Distinguir dimensiones y medidas.
- Crear campos calculados verificables.
- Elegir el gráfico según la pregunta de negocio.
- Crear filtros y acciones para que el dashboard sea interactivo.
- Mantener títulos, etiquetas, colores y leyendas consistentes.

## Preguntas de autoevaluación

1. ¿Qué JOIN conserva todas las filas de la tabla izquierda?
2. ¿Cuándo debe usarse `HAVING` en lugar de `WHERE`?
3. ¿Qué debe pasar si una reserva ya existe para la misma mesa y fecha?
4. ¿Por qué una operación de reserva puede necesitar una transacción?
5. ¿Cómo se evita guardar una contraseña MySQL en el código Python?
6. ¿Cuál es la diferencia entre una dimensión y una medida en Tableau?
7. ¿Qué evidencia demuestra que un dashboard es interactivo?
