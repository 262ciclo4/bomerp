# LP2 - Producto de Unidad 1

**Este documento es el ejemplo BomERP del docente, no una plantilla obligatoria.** Cada sede (Lima, Juliaca, Tarapoto) y cada grupo dentro de una misma sede tiene su propio dominio, definido en su propio [brief.md](../brief.md) de S2 — los endpoints, DTO y módulos concretos de este documento (`catalogo`/`ventas`) son los del ejemplo BomERP; cada equipo los reemplaza por sus propios módulos transaccional y no transaccional. Lo exigible a todos es la estructura: monolito modular verificado con Spring Modulith, un módulo transaccional con cabecera-detalle real, persistencia, consultas, CORS, logs y pruebas.

## Producto

**Backend REST modular ensamblado como una sola aplicación Spring Boot, conectado a Oracle, con persistencia ORM, CRUD, una operación cabecera–detalle, consultas, CORS, logs y pruebas.**

La demo representa una consola académica de API REST y muestra el flujo obligatorio `Categoria–Producto–Venta–DetalleVenta`, heredado del sistema MVC de Ciclo 3. El backend real se organiza como monolito modular: `catalogo` y `ventas` quedan funcionales en U1; `inventario`, `compras` y `seguridad` conservan límites preparados para su evolución. Para publicarse en MkDocs sin servidor, la demo simula servicios, repositorios y persistencia en el navegador; no reemplaza la aplicación Spring Boot conectada a Oracle. La autenticación JWT no forma parte de U1 y se incorpora en S10.

## Alcance arquitectónico del corte

```text
backend/                     # un solo proyecto Maven, sin reactor multi-módulo
└── src/main/java/pe/edu/upeu/bomerp/
    ├── BomErpApplication.java   # único Spring Boot ejecutable
    ├── catalogo/                # funcional en U1
    ├── ventas/                  # funcional en U1
    ├── inventario/              # aún no existe, se agrega cuando su sesión le dé contenido
    ├── compras/                 # aún no existe, se agrega cuando su sesión le dé contenido
    └── seguridad/               # se implementa en U2
```

Cada paquete directo bajo `pe.edu.upeu.bomerp` es un módulo de aplicación verificado por Spring Modulith (`ModularityTests`), no un artefacto Maven separado.

Compras no es un segundo flujo obligatorio de U1. Su límite se documenta para evitar que el código de compras termine mezclado con ventas, pero la evaluación mantiene una sola operación cabecera–detalle implementada con profundidad.

## Demo ejecutable

[Abrir consola API U1](demo-api/index.html)

## Contrato REST de referencia

| Método | Endpoint | Propósito | Sesión relacionada |
|---|---|---|---|
| `GET` | `/api/v1/categorias` | Listar categorías. | S1-S3 |
| `GET` | `/api/v1/productos` | Listar productos con categoría. | S1-S3 |
| `POST` | `/api/v1/productos` | Registrar un producto. | S2 |
| `POST` | `/api/v1/ventas` | Registrar cabecera y colección de detalles. | S4 |
| `GET` | `/api/v1/ventas` | Consultar ventas mediante filtros y ordenamiento. | S5 |
| `GET` | `/api/v1/ventas/resumen` | Devolver agregaciones y respuestas resumidas. | S5 |

## DTO principales

```json
{
  "detalles": [
    { "productoId": 1, "cantidad": 2 },
    { "productoId": 2, "cantidad": 3 }
  ]
}
```

```json
{
  "id": 1001,
  "fecha": "2026-09-01T10:15:00",
  "estado": "REGISTRADA",
  "total": 145.50,
  "detalles": [
    { "productoId": 1, "nombreProducto": "Producto de prueba", "precioUnitario": 50.00, "cantidad": 2, "subtotal": 100.00 }
  ]
}
```

## Arquitectura backend U1

```mermaid
flowchart LR
    APP[BomErpApplication<br/>único ejecutable]
    CAT[catalogo<br/>Categoria–Producto]
    VEN[ventas<br/>Venta–DetalleVenta]
    FUT["inventario, compras, seguridad<br/>(aún no creados como paquetes)"]

    SCAT[(BOM_CATALOGO)]
    SVEN[(BOM_VENTAS)]

    APP --> CAT
    APP --> VEN
    APP -. se agregan cuando su sesión les da contenido .-> FUT
    VEN -->|servicio público| CAT
    CAT --> SCAT
    VEN --> SVEN
```

Todos los módulos se ejecutan en la misma JVM y utilizan un datasource. No existe Feign ni comunicación HTTP interna. Cada módulo conserva sus controllers, casos de uso, entidades y repositorios; los repositorios no se comparten.

## Casos de prueba de la demo

| Caso | Accion | Resultado esperado |
|---|---|---|
| Verificar backend | Ejecutar con el ambiente local. | Conecta con Oracle y responde en `/health` o equivalente. |
| Verificar límites | Revisar dependencias y paquetes de negocio. | Existe un solo ejecutable y ningún módulo accede a repositorios ajenos. |
| CRUD maestro | Crear, consultar, actualizar y eliminar un producto. | Las operaciones persisten con respuestas HTTP consistentes. |
| Crear venta válida | Dos detalles válidos. | Se registra venta `REGISTRADA` con total y stock consistentes. |
| Crear venta inválida | Cantidad cero o stock insuficiente. | Se devuelve error `400`/`409` sin persistencia parcial (rollback completo). |
| Filtrar ventas | Filtrar por estado y rango de fecha. | La lista muestra solo las ventas coincidentes. |

## Trazabilidad con ADS y BD2

| Elemento LP2 | ADS | BD2 |
|---|---|---|
| Configuración por ambientes | Un ejecutable desplegable y configuración externa | Conexión Oracle sin credenciales versionadas. |
| Monolito modular con capas internas | Vista C3, límites y dependencias | Esquemas y tablas con propiedad funcional definida. |
| Validación de total y stock | Regla de integridad | Restricciones y excepciones PL/SQL. |
| Filtros por fecha | Atributo rendimiento | Índice `IX_VENTAS_FECHA`. |
