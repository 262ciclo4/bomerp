# BD2 - Producto de Unidad 2

**Este documento es el ejemplo BomERP del docente, no una plantilla obligatoria.** Cada sede (Lima, Juliaca, Tarapoto) y cada grupo dentro de una misma sede administra su propio esquema Oracle, definido desde su propio [brief.md](../brief.md) de S2. Los scripts y roles concretos de este documento son los del ejemplo BomERP; cada equipo los reemplaza por los de su propio proyecto. Lo exigible a todos es la estructura: seguridad (usuarios, roles, privilegios), almacenamiento y auditoría, y particionamiento/rendimiento.

## Producto

**Base de datos empresarial administrada, optimizada y asegurada.**

## Scripts del producto

| Script | Uso |
|---|---|
| [01_security.sql](oracle/01_security.sql) | Usuarios, roles y privilegios. |
| [02_storage_audit.sql](oracle/02_storage_audit.sql) | Tablespace, auditoría y estructura operativa. |
| [03_partition_perf.sql](oracle/03_partition_perf.sql) | Particionamiento, estadísticas e índices. |

## Evidencias esperadas

| Dimensión | Evidencia |
|---|---|
| Arquitectura Oracle | ORACLE_HOME, ORACLE_SID, SGA, PGA y procesos principales documentados. |
| Seguridad | Usuarios, roles, privilegios y mínimo privilegio. |
| Almacenamiento | Tablespace, datafile, segmentos y estrategia de crecimiento. |
| Auditoría | Auditoría de acceso o sentencias críticas. |
| Rendimiento | Explain Plan, DBMS_STATS, índices y consultas críticas. |
| Escalabilidad | Particionamiento o justificación técnica cuando no aplique. |

## Integración con ADS y LP2

| BD2 | ADS | LP2 |
|---|---|---|
| Rol `rol_app_erp` | Atributo seguridad | Backend usa usuario de aplicación. |
| Auditoría de ventas | Requisito de auditabilidad | SPA ejecuta registro o anulación auditable. |
| Índice/partición por fecha | Atributo rendimiento | Filtros de ventas por estado/fecha. |
| Estadísticas actualizadas | Decisión de optimización | Consultas de API más estables. |
