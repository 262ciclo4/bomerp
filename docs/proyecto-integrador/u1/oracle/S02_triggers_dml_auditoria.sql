-- BD2 - S02 Triggers DML y Auditoria Basica
-- Script completo y listo para ejecutar (ver explicacion en
-- docs/bd2/sesiones/S02_Triggers_DML_Auditoria.md, seccion 3).
--
-- Requisito: haber ejecutado antes S01_01_esquemas.sql y S01_02_tablas.sql
-- (crea BOM_CATALOGO.producto, sobre la que este trigger se dispara).

-- ============================================================
-- 1) Tabla de auditoria
-- ============================================================
CREATE TABLE BOM_CATALOGO.producto_auditoria (
    id_auditoria      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_producto       NUMBER NOT NULL,
    precio_anterior   NUMBER(10,2),
    precio_nuevo      NUMBER(10,2),
    stock_anterior    NUMBER,
    stock_nuevo       NUMBER,
    usuario_bd        VARCHAR2(60) DEFAULT USER,
    fecha_cambio      DATE DEFAULT SYSDATE
);

-- ============================================================
-- 2) Trigger AFTER UPDATE FOR EACH ROW, con :OLD y :NEW
-- ============================================================
CREATE OR REPLACE TRIGGER BOM_CATALOGO.trg_producto_auditoria
AFTER UPDATE ON BOM_CATALOGO.producto
FOR EACH ROW
WHEN (NVL(OLD.precio, -1) != NVL(NEW.precio, -1)
      OR NVL(OLD.stock, -1) != NVL(NEW.stock, -1))
DECLARE
BEGIN
    INSERT INTO BOM_CATALOGO.producto_auditoria (
        id_producto, precio_anterior, precio_nuevo, stock_anterior, stock_nuevo
    ) VALUES (
        :NEW.id_producto, :OLD.precio, :NEW.precio, :OLD.stock, :NEW.stock
    );
END;
/
