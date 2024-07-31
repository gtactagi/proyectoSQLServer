-- Añadir claves foráneas a la tabla Empleados
ALTER TABLE Empleados
ADD FOREIGN KEY (id_sucursal) REFERENCES Sucursales(id_sucursal);

ALTER TABLE Empleados
ADD FOREIGN KEY (id_sector_sucursal) REFERENCES Sectores(id_sector);

-- Añadir claves foráneas a la tabla Productos
ALTER TABLE Productos
ADD FOREIGN KEY (id_sucursal) REFERENCES Sucursales(id_sucursal);

ALTER TABLE Productos
ADD FOREIGN KEY (id_sector) REFERENCES Sectores(id_sector);