-- Basic queries

SELECT * FROM incidentes;

SELECT titulo, prioridad, estado
FROM incidentes;


-- Filtering

SELECT *
FROM incidentes
WHERE prioridad = 'Alta';

SELECT *
FROM incidentes
WHERE prioridad IN ('Alta', 'Media');


-- Pattern matching

SELECT *
FROM incidentes
WHERE titulo LIKE '%POS%';


-- Ranges

SELECT *
FROM incidentes
WHERE id BETWEEN 2 AND 4;


-- Aggregations

SELECT estado, COUNT(*) AS cantidad
FROM incidentes
GROUP BY estado;


-- Group filtering

SELECT categoria, COUNT(*) AS cantidad
FROM incidentes
GROUP BY categoria
HAVING cantidad > 2;


-- Filtering + grouping + ordering

SELECT categoria, COUNT(*) AS cantidad
FROM incidentes
WHERE estado = 'Abierto'
GROUP BY categoria
ORDER BY cantidad DESC;
