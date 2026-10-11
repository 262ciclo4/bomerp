-- S10 - Optimizacion del rendimiento (BD2, U2)
-- Verificado contra bomerp-oracle (gvenzl/oracle-free:23-slim), 2026-10-10.
-- Ver docs/bd2/sesiones/S10_Optimizacion_Rendimiento.md para la explicacion completa.

-- =====================================================================
-- 3.1 Reconstruir volumen de S4 e indices de S5, si faltan
-- Conectado como BOMERP_APP (unico usuario con privilegio sobre los dos
-- esquemas, via ROL_APP_CATALOGO/ROL_APP_VENTAS, S8).
-- =====================================================================

DECLARE
    v_id_venta      NUMBER;
    v_max_producto  NUMBER;
BEGIN
    SELECT MAX(ID) INTO v_max_producto FROM BOM_CATALOGO.PRODUCTOS;

    FOR i IN 1..500 LOOP
        INSERT INTO BOM_VENTAS.VENTAS (FECHA, ESTADO, TOTAL)
        VALUES (SYSTIMESTAMP - MOD(i, 90), 'REGISTRADA', 0)
        RETURNING ID INTO v_id_venta;

        FOR j IN 1..(MOD(i, 3) + 1) LOOP
            INSERT INTO BOM_VENTAS.DETALLE_VENTAS
                (ID_VENTA, ID_PRODUCTO, NOMBRE_PRODUCTO, PRECIO_UNITARIO, CANTIDAD, SUBTOTAL)
            VALUES
                (v_id_venta, MOD(i + j, v_max_producto) + 1, 'Producto de prueba', 50.00, j,
                 50.00 * j);
        END LOOP;
    END LOOP;
    COMMIT;
END;
/

-- Conectado como BOM_VENTAS (dueno del esquema) para los indices:
-- CREATE INDEX ix_ventas_fecha ON VENTAS (FECHA);
-- CREATE INDEX ix_ventas_fecha_dia ON VENTAS (TRUNC(FECHA));

-- =====================================================================
-- 3.2 Actualizar estadisticas (conectado como BOM_VENTAS)
-- =====================================================================

BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'VENTAS', CASCADE => TRUE);
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'DETALLE_VENTAS', CASCADE => TRUE);
END;
/

-- =====================================================================
-- 3.3 Consulta representativa (conectado como BOMERP_APP)
-- =====================================================================

EXPLAIN PLAN FOR
SELECT p.NOMBRE, SUM(d.CANTIDAD) AS TOTAL_UNIDADES, SUM(d.SUBTOTAL) AS TOTAL_VENDIDO
FROM BOM_VENTAS.DETALLE_VENTAS d
JOIN BOM_VENTAS.VENTAS v ON v.ID = d.ID_VENTA
JOIN BOM_CATALOGO.PRODUCTOS p ON p.ID = d.ID_PRODUCTO
WHERE v.FECHA >= TRUNC(SYSDATE) - 30
GROUP BY p.NOMBRE
ORDER BY TOTAL_VENDIDO DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- =====================================================================
-- 3.5 AWR: snapshot real (conectado como system o sys as sysdba)
-- Verificado: corre sin error en Oracle Database Free 23ai-slim.
-- =====================================================================

BEGIN
    DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT();
END;
/

SELECT SNAP_ID, BEGIN_INTERVAL_TIME FROM DBA_HIST_SNAPSHOT ORDER BY SNAP_ID DESC FETCH FIRST 3 ROWS ONLY;

-- =====================================================================
-- 3.6 Alternativa sin licencia: V$SQL / DISPLAY_CURSOR
-- Conectado como system (BOMERP_APP no tiene privilegio sobre V$).
-- =====================================================================

SELECT SQL_ID, SUBSTR(SQL_TEXT, 1, 50) AS SQL_PARCIAL
FROM V$SQL
WHERE SQL_TEXT LIKE 'SELECT p.NOMBRE%'
  AND SQL_TEXT LIKE '%TOTAL_UNIDADES%';

-- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('&sql_id', NULL, 'ALLSTATS LAST'));

-- =====================================================================
-- 3.7 Selectividad e indice compuesto (conectado como BOM_VENTAS)
-- Verificado: ESTADO='REGISTRADA' es 99.8% de las filas -> el indice
-- compuesto, medido, no se usa (misma razon de fondo que S5 con ESTADO solo).
-- =====================================================================

SELECT ESTADO, COUNT(*) AS TOTAL,
       ROUND(COUNT(*) / (SELECT COUNT(*) FROM VENTAS) * 100, 2) AS PORCENTAJE
FROM VENTAS
GROUP BY ESTADO;

EXPLAIN PLAN FOR
SELECT ID, ESTADO, TOTAL, FECHA
FROM VENTAS
WHERE ESTADO = 'REGISTRADA'
ORDER BY FECHA DESC
FETCH FIRST 20 ROWS ONLY;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX ix_ventas_estado_fecha ON VENTAS (ESTADO, FECHA DESC);

BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'VENTAS', CASCADE => TRUE);
END;
/

-- Repetir el EXPLAIN PLAN de arriba y comparar.
