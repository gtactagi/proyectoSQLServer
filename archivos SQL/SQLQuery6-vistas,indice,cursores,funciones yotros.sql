--informacion en sucursal 4
SELECT e.nombre_completo, p.nombre_producto
FROM Empleados e
INNER JOIN Productos p ON e.id_sucursal = p.id_sucursal
WHERE e.id_sucursal = 4;

--acelerar busquedas para id_sucurusal
CREATE INDEX idx_id_sucursal_producto ON Productos(id_sucursal);


--vsita para ver resumen de sucursal
CREATE VIEW ResumenSucursales AS
SELECT 
    s.id_sucursal,
    s.ciudad_ubicacion,
    SUM(p.costo_producto) AS TotalCostoAnual,
    SUM(p.precio_venta * p.unidades_vendidas_anual) AS TotalIngresoAnual
FROM 
    Sucursales s
LEFT JOIN 
    Productos p ON s.id_sucursal = p.id_sucursal
GROUP BY 
    s.id_sucursal, s.ciudad_ubicacion;


	CREATE PROCEDURE ActualizarSalarioEmpleado
    @id_empleado INT,
    @nuevo_salario DECIMAL(18, 2)
AS
BEGIN
    -- Actualizar salario
    UPDATE Empleados
    SET salario_anual = @nuevo_salario
    WHERE id_empleado = @id_empleado;

    -- Registrar cambio en la tabla de auditoría (asumiendo que existe)
    INSERT INTO AuditoriaSalarios (id_empleado, salario_nuevo, fecha_cambio)
    VALUES (@id_empleado, @nuevo_salario, GETDATE());
END

CREATE FUNCTION CalcularGananciaNeta
(
    @costo DECIMAL(18, 2),
    @precio_venta DECIMAL(18, 2)
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    RETURN @precio_venta - @costo;
END

CREATE TRIGGER ActualizarCostoAnual
ON Productos
AFTER INSERT
AS
BEGIN
    UPDATE Sucursales
    SET costo_anual = (
        SELECT SUM(costo_producto)
        FROM Productos
        WHERE id_sucursal = inserted.id_sucursal
    )
    FROM inserted
    WHERE Sucursales.id_sucursal = inserted.id_sucursal;
END



CREATE PROCEDURE AsignarBonos
AS
BEGIN
    DECLARE @id_empleado INT;
    DECLARE @salario DECIMAL(18, 2);
    DECLARE @antiguedad INT;

    DECLARE empleado_cursor CURSOR FOR
    SELECT id_empleado, salario_anual, antiguedad
    FROM Empleados;

    OPEN empleado_cursor;

    FETCH NEXT FROM empleado_cursor INTO @id_empleado, @salario, @antiguedad;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @antiguedad > 5 AND @salario > 50000
        BEGIN
            UPDATE Empleados
            SET salario_anual = salario_anual + 5000
            WHERE id_empleado = @id_empleado;
        END

        FETCH NEXT FROM empleado_cursor INTO @id_empleado, @salario, @antiguedad;
    END

    CLOSE empleado_cursor;
    DEALLOCATE empleado_cursor;
END

DECLARE @id_producto INT;
DECLARE @precio_venta DECIMAL(18, 2);

-- Declara el cursor para seleccionar los productos
DECLARE productos_cursor CURSOR FOR
SELECT id_producto, precio_venta
FROM Productos;

-- Abre el cursor
OPEN productos_cursor;

-- Fetch la primera fila del cursor
FETCH NEXT FROM productos_cursor INTO @id_producto, @precio_venta;

-- Bucle para recorrer todas las filas del cursor
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Realiza la actualización de precios (aumentar precio en un 10%, por ejemplo)
    UPDATE Productos
    SET precio_venta = @precio_venta * 1.10
    WHERE id_producto = @id_producto;

    -- Fetch la siguiente fila del cursor
    FETCH NEXT FROM productos_cursor INTO @id_producto, @precio_venta;
END;

-- Cierra y libera el cursor
CLOSE productos_cursor;
DEALLOCATE productos_cursor;