# RMAN Backup - Evidencia U3

**Ejemplo BomERP, verificado en vivo contra `bomerp-oracle` (S13).** Cada equipo reemplaza estos resultados por los de su propia instancia.

## Objetivo

Demostrar que la base Oracle del proyecto puede respaldarse como parte de la continuidad del negocio, con `ARCHIVELOG` activo y una estrategia completo + incremental real.

## Activar `ARCHIVELOG` (condición previa, S13 3.4)

```sql
ALTER SYSTEM SET db_recovery_file_dest_size = 10G SCOPE=BOTH;
ALTER SYSTEM SET db_recovery_file_dest = '/opt/oracle/oradata/FRA' SCOPE=BOTH;
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
```

## Backup completo (*Level 0*)

```sql
RMAN> CONFIGURE CONTROLFILE AUTOBACKUP ON;
RMAN> BACKUP INCREMENTAL LEVEL 0 DATABASE PLUS ARCHIVELOG;
```

Resultado real (resumido): 6 piezas de respaldo (`archivelog` + `Level 0` del CDB raíz, de `FREEPDB1` y de `pdbseed` + `archivelog` final + *controlfile autobackup*), confirmadas con `LIST BACKUP SUMMARY`.

## Backup incremental (*Level 1*)

```sql
RMAN> BACKUP INCREMENTAL LEVEL 1 DATABASE PLUS ARCHIVELOG;
```

Resultado real: los datafiles de `pdbseed` (que no cambiaron) se omitieron por completo (`skipping datafile ... because it has not changed` — `channel ORA_DISK_1: backup cancelled because all files were skipped`); los de `FREEPDB1` sí se respaldaron, porque un `INSERT` real sobre `BOM_VENTAS.VENTAS` sí los modificó.

## Evidencia requerida

| Evidencia | Descripción | Resultado real BomERP |
|---|---|---|
| Fecha y hora | Momento de ejecución. | 01-NOV-2026, ~02:22-02:26 UTC. |
| Comando ejecutado | Backup completo o incremental. | `BACKUP INCREMENTAL LEVEL 0/1 DATABASE PLUS ARCHIVELOG`. |
| Log o captura | Resultado exitoso o error documentado. | Éxito en ambos; `LIST BACKUP SUMMARY` con 11 piezas acumuladas. |
| Ubicación del backup | Ruta o catálogo usado. | `/opt/oracle/oradata/FRA` — dentro del volumen persistente (`oracle-data`), nunca fuera de él. |
| Responsable | Integrante que ejecutó y explicó el proceso. | (completar por equipo) |

Ver la guía completa de la sesión: [`S13_Backup_Recovery_RMAN.md`](../../../bd2/sesiones/S13_Backup_Recovery_RMAN.md).
