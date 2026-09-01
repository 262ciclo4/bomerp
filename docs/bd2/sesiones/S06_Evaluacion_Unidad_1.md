# S06 - Evaluación de la Unidad I

## 1. Propósito de la evaluación

Esta sesión no enseña contenido nuevo: cierra la Unidad I de **BD2**. El sílabo (sesión 6) define dos actividades para esta evaluación:

1. Resolver la evaluación teórico-práctica de los temas de la Unidad I (sesiones 1 a 5).
2. Presentar y sustentar el Motor transaccional Oracle optimizado.

**Esta sesión coincide con el "Primer corte integrado" de los tres cursos**, según el cronograma del Proyecto Integrador. ADS ya evaluó su arquitectura en su propia sesión 5, la semana anterior; LP2 evalúa su backend REST esta misma semana, en su propia sesión 6. La sustentación de hoy es individual de BD2 — tu esquema, tus objetos Oracle, tu evidencia —, pero la sección 4 exige además evidencia de que ese motor transaccional sostiene realmente al backend de LP2, no aislado.

## 2. Producto evaluado

Del sílabo, el producto de la Unidad I es:

> Motor transaccional implementado en Oracle XE con PL/SQL, triggers, excepciones, optimización de consultas e índices documentados y sustentados.

Ese producto ya existe como [`docs/proyecto-integrador/u1/bd2-producto.md`](../../proyecto-integrador/u1/bd2-producto.md). Esta sección lo reproduce completo para que la sesión sea autocontenida; `bd2-producto.md` sigue siendo la fuente única — si hay una edición futura, se hace ahí y se refleja aquí.

**Lo que sigue (2.1-2.4) es el ejemplo BomERP del docente, no una plantilla obligatoria.** Cada sede (Lima, Juliaca, Tarapoto) y cada grupo dentro de una misma sede tiene su propio dominio, definido en su propio `brief.md` de S2 — los esquemas, tablas, paquetes PL/SQL y triggers concretos de esta sección son los del ejemplo BomERP; cada equipo los reemplaza por los de su propio proyecto. Lo exigible a todos es la estructura: motor transaccional con reglas de negocio en PL/SQL, manejo de excepciones, auditoría y optimización con índices según selectividad medida.

### Lo que acumulaste sesión por sesión

Este producto no se construye en S06: se ensambla con lo que cada sesión anterior ya te pidió sobre tu propio proyecto.

**Tabla 1. De la sesión al motor transaccional evaluado**

| Sesión | Qué produjiste (tu propio proyecto) | Dónde queda en tu motor evaluado |
|---|---|---|
| S1 | Esquema y tablas base, con procedimientos y funciones PL/SQL para tus operaciones. | 2.1 Objetos Oracle |
| S2 | Triggers para automatizar una regla de negocio y registrar auditoría básica. | 2.1 Objetos Oracle y 2.2 Reglas de negocio |
| S3 | Manejo de excepciones predefinidas y personalizadas, con registro de errores. | 2.3 Manejo de excepciones |
| S4 | Una consulta representativa optimizada con `EXPLAIN PLAN` y `DBMS_STATS`. | 2.1 Objetos Oracle |
| S5 | Selectividad medida e índices B-Tree, Bitmap y Function-Based creados según esa medición. | 2.4 Selectividad e índices |
| S6 (esta sesión) | Ensamblas todo lo anterior en un motor transaccional único y lo sustentas. | El motor completo + sección 4 de esta guía |

Lo que sustentas en S06 es **tu motor transaccional**: los objetos que tú construiste, con las reglas y los datos de tu propio dominio — no el de BomERP. Las secciones 2.1-2.4 muestran cómo se ve ese motor terminado usando el ejemplo del docente; tu entregable real tiene la misma estructura, pero con el contenido que tú construiste en S1-S5.

### 2.1 Objetos Oracle (ejemplo BomERP)

**Estado al cierre de la Unidad 1 (S6):**

**Tabla 2. Objetos Oracle U1 (ejemplo BomERP)**

| Objeto | Propósito | Relación con LP2 |
|---|---|---|
| `BOM_CATALOGO.CATEGORIAS`/`PRODUCTOS` | Catálogo heredado de Ciclo 3. | Recursos `/api/v1/categorias` y `/api/v1/productos`. |
| `BOM_CATALOGO.LOG_ERRORES` | Registro de errores capturados por los procedimientos/función del catálogo (S3). | Ninguno directo — el backend no consulta esta tabla. |
| `BOM_CATALOGO.PRODUCTO_AUDITORIA` + `TRG_PRODUCTO_AUDITORIA` | Auditoría de cambios de precio/stock. | `POST`/`PUT` sobre `/api/v1/productos` (cualquier alta o cambio la dispara). |
| `BOM_VENTAS.VENTAS`/`DETALLE_VENTAS` | Operación transaccional principal. | Recurso `/api/v1/ventas`. |
| `IX_VENTAS_FECHA` (B-Tree) | Consultas filtradas por rango de fecha. | `GET /api/v1/ventas?desde=&hasta=`. |
| `IX_LOG_ERRORES_OBJETO` (Bitmap) | Diagnóstico de errores agrupados por objeto que falló. | Ninguno directo. |
| `IX_VENTAS_FECHA_DIA` (Function-Based, sobre `TRUNC(FECHA)`) | Reporte de ventas por día calendario. | `GET /api/v1/ventas/resumen`. |

### 2.2 Reglas de negocio y transaccionales (ejemplo BomERP)

**Tabla 3. Reglas de negocio y transaccionales (ejemplo BomERP)**

| Regla | Implementación Oracle |
|---|---|
| Un producto se registra con una categoría que debe existir. | `SP_REGISTRAR_PRODUCTO`, captura `ORA-02291` y la registra en `LOG_ERRORES`. |
| Un descuento no puede dejar el precio fuera de rango razonable. | `TRG_PRODUCTO_PRECIO_BU` (`BEFORE UPDATE`), rechaza con `RAISE_APPLICATION_ERROR` antes de escribir. |
| Todo cambio de precio o stock queda auditado, sin que el backend lo sepa. | `TRG_PRODUCTO_AUDITORIA` (`AFTER INSERT`/`UPDATE`/`DELETE`), disparado por Oracle mismo. |
| Una venta no puede registrarse con stock insuficiente. | Validado desde el servicio de `ventas` en LP2 (S4), consultando `catalogo` vía su servicio público. |
| Un producto inexistente al consultar su precio responde con causa clara. | `FN_OBTENER_PRECIO_PRODUCTO`, captura `NO_DATA_FOUND` y la registra en `LOG_ERRORES`. |

### 2.3 Manejo de excepciones (ejemplo BomERP)

**Tabla 4. Manejo de excepciones (ejemplo BomERP)**

| Situación | Excepción esperada |
|---|---|
| Categoría inexistente al registrar un producto. | `ORA-02291` capturado, `RAISE_APPLICATION_ERROR(-20010, ...)`. |
| Porcentaje de descuento fuera de rango (0-100). | `RAISE_APPLICATION_ERROR(-20011, ...)`, sin código Oracle previo — la regla la crea el propio procedimiento. |
| Producto inexistente al consultar su precio. | `NO_DATA_FOUND` (código `100`), `RAISE_APPLICATION_ERROR(-20012, ...)`. |

### 2.4 Selectividad e índices (ejemplo BomERP)

Ningún índice se crea sin medir selectividad primero (`COUNT(DISTINCT columna) / COUNT(*)`):

**Tabla 5. Selectividad e índices (ejemplo BomERP)**

| Columna candidata | Selectividad | Índice creado |
|---|---|---|
| `VENTAS.FECHA` | Alta (cercana a 1) | B-Tree (`IX_VENTAS_FECHA`) |
| `LOG_ERRORES.OBJETO` | Baja (pocos valores distintos) | Bitmap (`IX_LOG_ERRORES_OBJETO`) |
| `TRUNC(VENTAS.FECHA)` | La de la expresión, no la de la columna | Function-Based (`IX_VENTAS_FECHA_DIA`) |
| `VENTAS.ESTADO` | Muy baja (un único valor) | **Ninguno** — se creó, se confirmó que el optimizador no lo usaba, y se eliminó. |

## 3. Evaluación teórico-práctica (S1-S5)

Cubre los cinco temas dictados antes de esta sesión. El docente puede tomarla escrita, oral o mixta.

**Tabla 6. Temario de la evaluación teórico-práctica**

| Sesión | Tema | Qué puede evaluar el docente |
|---|---|---|
| S1 | PL/SQL aplicado al negocio | Creación del esquema y las tablas base, procedimientos, funciones y parámetros `IN`/`OUT`/`IN OUT`. |
| S2 | Triggers DML | Pseudo-registros `:OLD`/`:NEW`, reglas automáticas de negocio y auditoría básica. |
| S3 | Manejo de excepciones y robustez | Excepciones predefinidas frente a personalizadas, registro de errores y tolerancia a fallos. |
| S4 | Optimización de consultas SQL | Cost Based Optimizer, `EXPLAIN PLAN`, `DBMS_STATS` y buenas prácticas SQL sin tocar índices. |
| S5 | Índices para optimización | B-Tree, Bitmap, Function-Based Index y por qué la selectividad decide, no la intuición. |

Preguntas de referencia (el docente puede formular equivalentes):

1. ¿Por qué un trigger `BEFORE` puede rechazar una operación y uno `AFTER` no?
2. ¿Qué diferencia hay entre una excepción predefinida de Oracle y una personalizada con `RAISE_APPLICATION_ERROR`, y cuándo usarías cada una?
3. ¿Por qué `EXPLAIN PLAN` no ejecuta realmente la consulta, y qué columna interpretarías mal si pensaras que `COST` es una medida absoluta?
4. ¿Qué mide la selectividad de una columna, y por qué no basta con eso para decidir si el optimizador usará un índice en una consulta concreta?
5. En tu propio proyecto, ¿qué columna tiene la selectividad más baja, y por qué decidiste (o no) crearle un índice?

## 4. Sustentación del motor transaccional

**Tabla 7. Distribución de tiempo por integrante**

| Momento | Tiempo | Propósito |
|---|---:|---|
| Presentación técnica | 8 min | Explicar el motor transaccional (sección 2), las decisiones tomadas y su justificación. |
| Demo técnica | 5 min | Ejecutar procedimientos, disparar un trigger, provocar una excepción y comparar un `EXPLAIN PLAN` antes/después de un índice. |
| Preguntas individuales | 5 min | Verificar dominio y aporte propio, con base en la Tabla 6. |

**Tabla 8. Entregables obligatorios**

| Entregable | Evidencia mínima | Criterio de aceptación |
|---|---|---|
| Producto de unidad | `bd2-producto.md` (sección 2 de esta guía) completo | Coherente con el sílabo y con los objetos Oracle reales |
| Evidencia de integración | Esquemas conectados y consumidos por el backend real de LP2, `EXPLAIN PLAN`/selectividad documentados | Trazabilidad verificable con ADS y LP2, no solo documentada |
| Sustentación individual | Preguntas y defensa por integrante (sección 3) | Autoría demostrada |

**Tabla 9. Evidencia de integración con ADS y LP2**

| BD2 | ADS | LP2 |
|---|---|---|
| `TRG_PRODUCTO_AUDITORIA` | Atributo de auditabilidad | `POST`/`PUT` sobre `/api/v1/productos`. |
| `IX_VENTAS_FECHA` | Atributo de rendimiento | `GET /api/v1/ventas?desde=&hasta=`. |
| `LOG_ERRORES` + excepciones personalizadas | Robustez del motor | `GlobalExceptionHandler` (manejo global de errores). |
| `EXPLAIN PLAN`/`DBMS_STATS` sobre la consulta representativa (S4) | — | Consulta de reporte agregado (`GET /api/v1/ventas/resumen`, LP2 S5). |

Secuencia sugerida de presentación:

1. Presentar los objetos Oracle (2.1) y las reglas de negocio implementadas (2.2).
2. Disparar en vivo un trigger de regla de negocio y uno de auditoría, mostrando el registro generado.
3. Provocar una excepción personalizada y mostrar su registro en la tabla de errores.
4. Comparar un `EXPLAIN PLAN` antes y después de un índice, explicando la selectividad medida que justificó la decisión.
5. Mostrar el caso de un índice descartado (Tabla 5, fila `ESTADO`) y explicar por qué no se creó.
6. Cerrar con la Tabla 9, explicando al menos una fila con evidencia en vivo desde el backend de LP2.

Criterios mínimos de aceptación:

- Los objetos Oracle existen y responden en vivo, no solo en captura de pantalla.
- Al menos un trigger de regla de negocio y uno de auditoría se disparan y se explican correctamente.
- Al menos una excepción personalizada se prueba con un caso real.
- La comparación de `EXPLAIN PLAN` incluye la selectividad medida que justificó el índice creado (o descartado).
- Cada integrante responde individualmente al menos una pregunta de la Tabla 6.

## 5. Rúbrica de evaluación

Los cinco criterios son cita literal del resultado de aprendizaje de la Unidad I en el sílabo de BD2.

**Tabla 10. Rúbrica de evaluación**

| Criterio | Peso | A (20 pts) | B (15 pts) | C (10 pts) | D (5 pts) | Nivel obtenido |
|---|---:|---|---|---|---|---:|
| 1. Implementa procedimientos y funciones PL/SQL alineados al negocio | 20% | Procedimientos y funciones correctos, probados con casos válidos e inválidos, alineados a una regla real del proyecto. | Procedimientos y funciones correctos, con pruebas parciales. | Procedimientos incompletos o sin alineación clara al negocio. | No presenta procedimientos ni funciones PL/SQL. | |
| 2. Automatiza reglas mediante triggers DML | 20% | Al menos un trigger de regla de negocio y uno de auditoría, disparados y verificados en vivo. | Triggers presentes, con verificación parcial. | Un solo trigger funcional, o sin verificación clara. | No presenta triggers. | |
| 3. Controla errores mediante manejo de excepciones | 20% | Excepciones predefinidas y personalizadas, con registro de errores probado con casos reales. | Manejo de excepciones presente, con registro parcial. | Manejo de excepciones incompleto o sin registro. | No maneja excepciones. | |
| 4. Analiza y mejora consultas mediante Explain Plan, CBO y DBMS_STATS | 20% | Comparación completa (antes/después de estadísticas y de una reescritura), con `COST`/`ROWS` interpretados correctamente. | Comparación presente, con interpretación parcial. | Un solo `EXPLAIN PLAN` capturado, sin comparación real. | No presenta `EXPLAIN PLAN`. | |
| 5. Aplica estrategias de indexación según selectividad y necesidades de consulta | 20% | Selectividad medida antes de crear cada índice, con al menos un caso de índice correctamente descartado. | Índices creados con selectividad medida, sin caso de descarte. | Índices creados sin medir selectividad. | No presenta índices ni selectividad medida. | |

Nota final = suma de (`Peso` × `Puntos del nivel obtenido`) / 100 × 20 = ____.

Para usar la rúbrica con IA, solicita:

```text
Evalúa la sustentación y el producto (bd2-producto.md o la sección 2 de esta guía) usando la rúbrica de esta sesión.
Para cada criterio selecciona el nivel obtenido: A=20, B=15, C=10, D=5.
Justifica brevemente cada nivel con evidencia concreta (objetos Oracle, planes de ejecución, selectividad).
Calcula la nota final con la fórmula: suma de (Peso × Puntos del nivel obtenido) / 100 × 20.
Indica 2 fortalezas y 2 recomendaciones para lo que sigue en Unidad II.
```
