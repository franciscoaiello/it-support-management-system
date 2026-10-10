ALTER TABLE incidentes
ADD COLUMN sucursal_id INT;

UPDATE incidentes
JOIN sucursales
ON incidentes.sucursal = sucursales.nombre
SET incidentes.sucursal_id = sucursales.id;
