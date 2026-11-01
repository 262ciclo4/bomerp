-- Consultas de monitoreo y diagnóstico - Evidencia U3
-- Ejemplo BomERP, verificado en vivo contra bomerp-oracle (S14).
-- Cada equipo las ejecuta contra su propia instancia.

-- 1. Sesiones activas
SELECT SID, SERIAL#, USERNAME, STATUS, SQL_ID
FROM V$SESSION
WHERE USERNAME IS NOT NULL;

-- 2. Bloqueos: quien bloquea, quien espera (ver 02_recovery_scenario.md no aplica aqui;
--    construir primero el bloqueo real con un UPDATE sin commit desde otra sesion, S14 3.3)
SELECT SID, STATUS, EVENT, BLOCKING_SESSION
FROM V$SESSION
WHERE USERNAME = 'SYSTEM' AND SID != USERENV('SID');

SELECT * FROM DBA_BLOCKERS;
SELECT * FROM DBA_WAITERS;

-- 3. Objetos invalidos
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS
FROM DBA_OBJECTS
WHERE STATUS != 'VALID';

-- Intento de recompilacion puntual (documentar el resultado real, exito o error)
-- ALTER PUBLIC SYNONYM <nombre> COMPILE;

-- 4. Rendimiento en vivo: buffer cache hit ratio
SELECT
  ROUND((1 - (phy.value / (cur.value + con.value))) * 100, 2) AS BUFFER_CACHE_HIT_RATIO
FROM V$SYSSTAT phy, V$SYSSTAT cur, V$SYSSTAT con
WHERE phy.name = 'physical reads'
  AND cur.name = 'db block gets'
  AND con.name = 'consistent gets';

-- Resultado real BomERP (S14, bajo la carga de la clase): 98.73
