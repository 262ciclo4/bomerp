-- BD2 - S01 PL/SQL Aplicado al Negocio
-- Paso 3: funcion (IN, IN), procedimiento (IN, OUT), procedimiento (IN OUT).
-- Requiere haber ejecutado antes S01_01_esquemas.sql y S01_02_tablas.sql.

CREATE OR REPLACE FUNCTION BOM_CATALOGO.fn_valor_inventario_producto(
    p_precio IN NUMBER,
    p_stock IN NUMBER
) RETURN NUMBER IS
BEGIN
    RETURN p_precio * p_stock;
END;
/

CREATE OR REPLACE PROCEDURE BOM_CATALOGO.sp_registrar_producto(
    p_id_categoria IN NUMBER,
    p_nombre IN VARCHAR2,
    p_precio IN NUMBER,
    p_stock IN NUMBER,
    p_id_producto OUT NUMBER
) IS
BEGIN
    INSERT INTO BOM_CATALOGO.producto (id_categoria, nombre, precio, stock)
    VALUES (p_id_categoria, p_nombre, p_precio, p_stock)
    RETURNING id_producto INTO p_id_producto;
END;
/

CREATE OR REPLACE PROCEDURE BOM_CATALOGO.sp_aplicar_descuento_producto(
    p_precio IN OUT NUMBER,
    p_porcentaje_descuento IN NUMBER
) IS
BEGIN
    p_precio := p_precio - (p_precio * p_porcentaje_descuento / 100);
END;
/
