CREATE TABLE Sucursales (
    id_sucursal INT PRIMARY KEY,
    ciudad_ubicacion VARCHAR(100),
    cantidad_empleados INT,
    costo_anual DECIMAL(18, 2),
    ingresos_anual DECIMAL(18, 2),
    ganancias DECIMAL(18, 2)
);

CREATE TABLE Sectores (
    id_sector INT PRIMARY KEY,
    id_sucursal INT,
    nombre_sector VARCHAR(100),
    costo_sector DECIMAL(18, 2),
    ganancia_generada DECIMAL(18, 2),
    FOREIGN KEY (id_sucursal) REFERENCES Sucursales(id_sucursal)
);

CREATE TABLE Empleados (
    id_empleado INT PRIMARY KEY,
    nombre_completo VARCHAR(100),
    salario_anual DECIMAL(18, 2),
    cargas_patronales_anuales DECIMAL(18, 2),
    antiguedad INT,
    id_sucursal INT,
    id_sector_sucursal INT,
    FOREIGN KEY (id_sucursal) REFERENCES Sucursales(id_sucursal),
    FOREIGN KEY (id_sector_sucursal) REFERENCES Sectores(id_sector)
);

CREATE TABLE Productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100),
    id_sucursal INT,
    id_sector INT,
    costo_producto DECIMAL(18, 2),
    precio_venta DECIMAL(18, 2),
    unidades_vendidas_anual INT,
    FOREIGN KEY (id_sucursal) REFERENCES Sucursales(id_sucursal),
    FOREIGN KEY (id_sector) REFERENCES Sectores(id_sector)
);
