# Escenario de Recovery - Evidencia U3

**Ejemplo BomERP, verificado en vivo contra `bomerp-oracle` (S13).** Cada equipo reemplaza este escenario por uno real de su propio proyecto.

## Objetivo

Demostrar que el equipo puede recuperar la base ante un incidente real, exactamente hasta el punto correcto en el tiempo (*Point-In-Time Recovery*, PITR) — no solo restaurar al último backup disponible.

## Escenario real ejecutado

1. Backup completo (L0) y datos reales de `BOM_VENTAS.VENTAS` ya existentes (504 filas).
2. `INSERT` real número 505 (`TOTAL=199.90`, `02:25:43`) — el cambio que **debe sobrevivir**.
3. Backup incremental (L1), que captura ese cambio.
4. `INSERT` real número 506 (`TOTAL=350.00`, `02:27:01`) — el **incidente simulado**, que debe descartarse.
5. `SHUTDOWN IMMEDIATE` + `STARTUP MOUNT`.
6. PITR con `SET UNTIL TIME` apuntando a `02:26:50` — entre los dos `INSERT`.
7. `ALTER DATABASE OPEN RESETLOGS`.

## Comandos reales

```sql
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
```

```text
RUN {
  SET UNTIL TIME "TO_DATE('2026-11-01 02:26:50','YYYY-MM-DD HH24:MI:SS')";
  RESTORE DATABASE;
  RECOVER DATABASE;
}
```

```sql
ALTER DATABASE OPEN RESETLOGS;
```

## Validación posterior (resultado real)

```sql
SELECT COUNT(*) FROM BOM_VENTAS.VENTAS;
-- 505 (no 506)

SELECT ID, TOTAL FROM BOM_VENTAS.VENTAS WHERE TOTAL IN (199.90, 350.00);
-- Solo aparece la fila de 199.90 (ID 2262) -- la de 350.00 nunca existió, desde el punto de vista
-- de la base ya recuperada.
```

## Evidencia requerida

| Evidencia | Descripción | Resultado real BomERP |
|---|---|---|
| Estado antes de la falla | Consulta o captura. | 504 filas en `BOM_VENTAS.VENTAS`. |
| Falla simulada | Descripción controlada del escenario. | Dos `INSERT` reales, el segundo es el "incidente" a descartar. |
| Comando de recuperación | Restore/recover o alternativa usada. | `RESTORE DATABASE` + `RECOVER DATABASE` con `SET UNTIL TIME`, seguido de `OPEN RESETLOGS`. |
| Validación posterior | Consulta y prueba desde la aplicación. | 505 filas; el cambio de `02:25:43` sobrevivió, el de `02:27:01` no. |
| Lección aprendida | Riesgo y mejora identificada. | El punto elegido para `SET UNTIL TIME` debe estar siempre después del último respaldo útil — nunca antes. |

Ver la guía completa de la sesión: [`S13_Backup_Recovery_RMAN.md`](../../../bd2/sesiones/S13_Backup_Recovery_RMAN.md).
