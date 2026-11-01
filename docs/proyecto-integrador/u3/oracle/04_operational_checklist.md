# Checklist Operativo BD2

**Ejemplo BomERP, resuelto contra el estado real de `bomerp-oracle` al cierre de S14.** Cada equipo marca su propio checklist contra su propia instancia.

| Revisión | Cumple | Evidencia |
|---|---|---|
| La instancia Oracle está disponible. | Sí | `SELECT 'ALIVE' FROM DUAL;` responde (S13, 3.1). |
| El usuario de aplicación tiene privilegios mínimos. | Sí | `BOMERP_APP` sin privilegios de propietario de esquema (S8). |
| Las tablas principales existen y están válidas. | Sí | `BOM_CATALOGO.CATEGORIAS/PRODUCTOS`, `BOM_VENTAS.VENTAS/DETALLE_VENTAS` — todas `VALID` en `DBA_OBJECTS`. |
| Los índices críticos existen. | Sí | Índices de S5/S10 verificados contra `DBA_INDEXES`. |
| Las estadísticas fueron actualizadas. | Sí | `DBMS_STATS` ejecutado en S4/S10. |
| La auditoría registra acciones críticas. | Sí | Unified Auditing activo desde S9. |
| Existe evidencia de backup. | Sí | `LIST BACKUP SUMMARY` con L0 + L1 reales (S13). |
| Existe escenario de recovery documentado. | Sí | PITR real, verificado con conteo de filas (S13, [`02_recovery_scenario.md`](02_recovery_scenario.md)). |
| Se revisaron sesiones, bloqueos y rendimiento. | Sí | Bloqueo real diagnosticado y resuelto, *buffer cache hit ratio* medido (S14). |
| La aplicación puede conectarse después de la validación. | Sí | `BOM_VENTAS.VENTAS` responde con 505 filas tras el `OPEN RESETLOGS` de S13. |

**Pendiente, documentado y sin bloquear el resto:** un sinónimo público (`SDO_AGGR_POINTAPPEND`, Oracle Spatial) quedó `INVALID` tras el cambio de imagen de S13 — ajeno a los esquemas `BOM_*`, no afecta a ninguna tabla ni procedimiento del proyecto (ver Anexo de [`S14_Monitoreo_Diagnostico.md`](../../../bd2/sesiones/S14_Monitoreo_Diagnostico.md)).
