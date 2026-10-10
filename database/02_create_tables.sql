CREATE TABLE sucursales (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    localidad VARCHAR(20),
    provincia VARCHAR(20),
    activa BOOLEAN
);

CREATE TABLE incidentes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    prioridad VARCHAR(20),
    estado VARCHAR(20),
    sucursal VARCHAR(100),
    sucursal_id INT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);
