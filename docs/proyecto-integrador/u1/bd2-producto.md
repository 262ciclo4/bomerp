# BD2 - Producto de Unidad 1

**Este documento es el ejemplo BomERP del docente, no una plantilla obligatoria.** Cada sede (Lima, Juliaca, Tarapoto) y cada grupo dentro de una misma sede tiene su propio dominio, definido en su propio [brief.md](../brief.md) de S2 — los esquemas, tablas, paquetes PL/SQL y triggers concretos de este documento son los del ejemplo BomERP; cada equipo los reemplaza por los de su propio proyecto. Lo exigible a todos es la estructura: motor transaccional con reglas de negocio en PL/SQL, manejo de excepciones, auditoría y optimización con índices y `EXPLAIN PLAN`.

## Producto

**Motor transaccional Oracle optimizado.**

Este producto implementa lógica de negocio en Oracle mediante PL/SQL, triggers, excepciones, auditoría básica, consultas optimizadas e índices. La base no se trabaja como ejercicio aislado: soporta los endpoints y reglas del backend LP2.

## 1. Scripts del producto

Los scripts se agregan **por sesión de BD2**, a medida que cada una les da contenido real — no se pre-crean tablas/objetos de sesiones que todavía no se dictaron (mismo criterio que la arquitectura de módulos de LP2, ver [ADR-002](../../lp2/adr/ADR-002-spring-modulith.md)).

| Script | Sesión BD2 | Uso |
|---|---|---|
| [S01_01_esquemas.sql](oracle/S01_01_esquemas.sql) | [S1](../../bd2/sesiones/S01_PLSQL_Aplicado_Negocio.md) | Usuarios `BOM_CATALOGO` (propietario) y `BOMERP_APP` (técnico de LP2). |
| [S01_02_tablas.sql](oracle/S01_02_tablas.sql) | [S1](../../bd2/sesiones/S01_PLSQL_Aplicado_Negocio.md) | Tablas `CATEGORIAS`/`PRODUCTOS` y permisos de `BOMERP_APP` sobre ellas. |
| [S01_03_plsql.sql](oracle/S01_03_plsql.sql) | [S1](../../bd2/sesiones/S01_PLSQL_Aplicado_Negocio.md) | Función y procedimientos PL/SQL del catálogo. |
| [S02_triggers_dml_auditoria.sql](oracle/S02_triggers_dml_auditoria.sql) | [S2](../../bd2/sesiones/S02_Triggers_DML_Auditoria.md) | Trigger de regla de negocio (`TRG_PRODUCTO_PRECIO_BU`) y trigger + tabla de auditoría de precio/stock (`TRG_PRODUCTO_AUDITORIA`, `PRODUCTO_AUDITORIA`). |
| (excepciones agregadas directo sobre los procedimientos de S1) | [S3](../../bd2/sesiones/S03_Excepciones_Robustez.md) | Manejo de excepciones personalizadas y tabla de registro de errores (`LOG_ERRORES`). |
| [S04_01_esquemas.sql](oracle/S04_01_esquemas.sql) | [S4](../../bd2/sesiones/S04_Optimizacion_Consultas_SQL.md) | Usuario `BOM_VENTAS`. |
| [S04_02_tablas.sql](oracle/S04_02_tablas.sql) | [S4](../../bd2/sesiones/S04_Optimizacion_Consultas_SQL.md) | Tablas `VENTAS`/`DETALLE_VENTAS`. |
| [S04_optimizacion_consultas.sql](oracle/S04_optimizacion_consultas.sql) | [S4](../../bd2/sesiones/S04_Optimizacion_Consultas_SQL.md) | Volumen de prueba, `EXPLAIN PLAN`, `DBMS_STATS` y reescritura de la consulta representativa. |
| [S05_indices_optimizacion.sql](oracle/S05_indices_optimizacion.sql) | [S5](../../bd2/sesiones/S05_Indices_Optimizacion.md) | Selectividad medida e índices B-Tree, Bitmap y Function-Based. |

Pendiente (se agrega cuando esa sesión de BD2 se documente): esquema `BOM_SEGURIDAD` (S10 de LP2).

## 2. Objetos Oracle U1

**Estado al cierre de la Unidad 1 (S6):**

| Objeto | Propósito | Relación con LP2 |
|---|---|---|
| `BOM_CATALOGO.CATEGORIAS`/`PRODUCTOS` | Catálogo heredado de Ciclo 3. | Recursos `/api/v1/categorias` y `/api/v1/productos`. |
| `BOM_CATALOGO.LOG_ERRORES` | Registro de errores capturados por los procedimientos/función del catálogo (S3). | Ninguno directo — el backend no consulta esta tabla. |
| `BOM_CATALOGO.PRODUCTO_AUDITORIA` + `TRG_PRODUCTO_AUDITORIA` | Auditoría de cambios de precio/stock. | `POST`/`PUT` sobre `/api/v1/productos` (cualquier alta o cambio la dispara). |
| `BOM_VENTAS.VENTAS`/`DETALLE_VENTAS` | Operación transaccional principal. | Recurso `/api/v1/ventas`. |
| `IX_VENTAS_FECHA` (B-Tree) | Consultas filtradas por rango de fecha. | `GET /api/v1/ventas?desde=&hasta=`. |
| `IX_LOG_ERRORES_OBJETO` (Bitmap) | Diagnóstico de errores agrupados por objeto que falló. | Ninguno directo. |
| `IX_VENTAS_FECHA_DIA` (Function-Based, sobre `TRUNC(FECHA)`) | Reporte de ventas por día calendario. | `GET /api/v1/ventas/resumen`. |

## 3. Reglas de negocio y transaccionales

| Regla | Implementación Oracle |
|---|---|
| Un producto se registra con una categoría que debe existir. | `SP_REGISTRAR_PRODUCTO`, captura `ORA-02291` y la registra en `LOG_ERRORES`. |
| Un descuento no puede dejar el precio fuera de rango razonable. | `TRG_PRODUCTO_PRECIO_BU` (`BEFORE UPDATE`), rechaza con `RAISE_APPLICATION_ERROR` antes de escribir. |
| Todo cambio de precio o stock queda auditado, sin que el backend lo sepa. | `TRG_PRODUCTO_AUDITORIA` (`AFTER INSERT`/`UPDATE`/`DELETE`), disparado por Oracle mismo. |
| Una venta no puede registrarse con stock insuficiente. | Validado desde el servicio de `ventas` en LP2 (S4), consultando `catalogo` vía su servicio público — regla de estado, no de forma, por eso vive en el service y no en un `CHECK`. |
| Un producto inexistente al consultar su precio responde con causa clara. | `FN_OBTENER_PRECIO_PRODUCTO`, captura `NO_DATA_FOUND` y la registra en `LOG_ERRORES`. |

## 4. Manejo de excepciones

| Situación | Excepción esperada |
|---|---|
| Categoría inexistente al registrar un producto. | `ORA-02291` capturado, `RAISE_APPLICATION_ERROR(-20010, ...)`. |
| Porcentaje de descuento fuera de rango (0-100). | `RAISE_APPLICATION_ERROR(-20011, ...)`, sin código Oracle previo — la regla la crea el propio procedimiento. |
| Producto inexistente al consultar su precio. | `NO_DATA_FOUND` (código `100`), `RAISE_APPLICATION_ERROR(-20012, ...)`. |

## 5. Selectividad e índices (S5)

Ningún índice se crea sin medir selectividad primero (`COUNT(DISTINCT columna) / COUNT(*)`):

| Columna candidata | Selectividad | Índice creado |
|---|---|---|
| `VENTAS.FECHA` | Alta (cercana a 1) | B-Tree (`IX_VENTAS_FECHA`) |
| `LOG_ERRORES.OBJETO` | Baja (pocos valores distintos) | Bitmap (`IX_LOG_ERRORES_OBJETO`) |
| `TRUNC(VENTAS.FECHA)` | La de la expresión, no la de la columna | Function-Based (`IX_VENTAS_FECHA_DIA`) |
| `VENTAS.ESTADO` | Muy baja (un único valor, `EstadoVenta.REGISTRADA` en LP2 S4) | **Ninguno** — se creó, se confirmó que el optimizador no lo usaba, y se eliminó. |

## 6. Evidencia de integración

| BD2 | ADS | LP2 |
|---|---|---|
| `TRG_PRODUCTO_AUDITORIA` | Atributo de auditabilidad | `POST`/`PUT` sobre `/api/v1/productos`. |
| `IX_VENTAS_FECHA` | Atributo de rendimiento | `GET /api/v1/ventas?desde=&hasta=`. |
| `LOG_ERRORES` + excepciones personalizadas | Robustez del motor | `GlobalExceptionHandler` (manejo global de errores). |
| `EXPLAIN PLAN`/`DBMS_STATS` sobre la consulta representativa (S4) | — | Consulta de reporte agregado (`GET /api/v1/ventas/resumen`, LP2 S5). |

Las FK entre esquemas conservan la integridad porque todos los objetos pertenecen a una sola base Oracle. `BOMERP_APP` ejecuta la aplicación, pero no es propietario de tablas ni paquetes.
