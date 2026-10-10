ALTER TABLE incidentes
ADD CONSTRAINT fk_incidentes_sucursal FOREIGN KEY (sucursal_id)
REFERENCES sucursales(id);
