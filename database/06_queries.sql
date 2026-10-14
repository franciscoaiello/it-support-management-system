-- =========================================
-- BASIC QUERIES
-- =========================================

SELECT * FROM incidentes;

SELECT titulo, prioridad, estado
FROM incidentes;

-- =========================================
-- FILTERING
-- =========================================

SELECT *
FROM incidentes
WHERE prioridad = 'Alta';

SELECT *
FROM incidentes
WHERE prioridad IN ('Alta', 'Media');

SELECT *
FROM incidentes
WHERE titulo LIKE '%POS%';

SELECT *
FROM incidentes
WHERE id BETWEEN 2 AND 4;

-- =========================================
-- AGGREGATIONS
-- =========================================

SELECT estado, COUNT(*) AS cantidad
FROM incidentes
GROUP BY estado;

SELECT categoria, COUNT(*) AS cantidad
FROM incidentes
GROUP BY categoria
HAVING cantidad > 2;

SELECT categoria, COUNT(*) AS cantidad
FROM incidentes
WHERE estado = 'Abierto'
GROUP BY categoria
ORDER BY cantidad DESC;

-- =========================================
-- INNER JOIN
-- =========================================

SELECT
    incidentes.titulo,
    incidentes.prioridad,
    sucursales.nombre,
    incidentes.estado
FROM incidentes
JOIN sucursales
ON sucursales.id = incidentes.sucursal_id;

-- Incidents from a specific branch

SELECT
    incidentes.titulo,
    incidentes.prioridad,
    incidentes.estado,
    sucursales.nombre
FROM incidentes
JOIN sucursales
ON incidentes.sucursal_id = sucursales.id
WHERE sucursales.nombre = 'Carrefour Belgrano';

-- Incident count by branch

SELECT
    sucursales.nombre,
    COUNT(*) AS cantidad
FROM incidentes
JOIN sucursales
ON incidentes.sucursal_id = sucursales.id
GROUP BY sucursales.nombre;

-- Open incidents by branch

SELECT
    sucursales.nombre,
    COUNT(*) AS cantidad
FROM incidentes
JOIN sucursales
ON incidentes.sucursal_id = sucursales.id
WHERE incidentes.estado = 'Abierto'
GROUP BY sucursales.nombre
ORDER BY cantidad DESC;

-- Open incidents by branch

SELECT
    sucursales.nombre,
    COUNT(*) AS cantidad
FROM incidentes
JOIN sucursales
ON incidentes.sucursal_id = sucursales.id
WHERE incidentes.estado = 'Abierto'
GROUP BY sucursales.nombre
ORDER BY cantidad DESC;

-- =========================================
-- LEFT JOIN
-- =========================================

-- All branches, including branches with zero incidents

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
LEFT JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
GROUP BY sucursales.nombre;

-- All branches with count of open incidents

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
LEFT JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
AND incidentes.estado = 'Abierto'
GROUP BY sucursales.nombre
ORDER BY cantidad DESC;

-- High-priority incidents by branch, including zero

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
LEFT JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
AND incidentes.prioridad = 'Alta'
GROUP BY sucursales.nombre
ORDER BY cantidad DESC;

-- POS incidents by branch, including zero

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
LEFT JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
AND incidentes.categoria = 'POS'
GROUP BY sucursales.nombre
ORDER BY cantidad DESC;

-- Resolved incidents by branch, including zero

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
LEFT JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
AND incidentes.estado = 'Resuelto'
GROUP BY sucursales.nombre
ORDER BY cantidad DESC;

-- =========================================
-- WHERE + GROUP BY + HAVING
-- =========================================

-- Branches with more than 2 incidents

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
GROUP BY sucursales.nombre
HAVING cantidad > 2;

-- Branches with at least 2 high-priority incidents

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
WHERE incidentes.prioridad = 'Alta'
GROUP BY sucursales.nombre
HAVING cantidad >= 2;

-- Buenos Aires branches with 2 or more incidents

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
LEFT JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
WHERE sucursales.provincia = 'Buenos Aires'
GROUP BY sucursales.nombre
HAVING cantidad >= 2
ORDER BY cantidad DESC;

-- CABA branches with high-priority incidents

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
WHERE sucursales.provincia = 'CABA'
AND incidentes.prioridad = 'Alta'
GROUP BY sucursales.nombre
ORDER BY cantidad DESC;

-- CABA branches with 2 or more open incidents

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
WHERE sucursales.provincia = 'CABA'
AND incidentes.estado = 'Abierto'
GROUP BY sucursales.nombre
HAVING cantidad >= 2
ORDER BY cantidad DESC;

-- =========================================
-- CASE / CONDITIONAL COUNTS
-- =========================================

-- Open and resolved incidents by branch

SELECT
    sucursales.nombre,
    COUNT(
        CASE
            WHEN incidentes.estado = 'Abierto' THEN 1
        END
    ) AS cantidad_abiertos,
    COUNT(
        CASE
            WHEN incidentes.estado = 'Resuelto' THEN 1
        END
    ) AS cantidad_resueltos
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
GROUP BY sucursales.nombre;

-- Open, resolved and in-analysis incidents by branch

SELECT
    sucursales.nombre,
    COUNT(
        CASE
            WHEN incidentes.estado = 'Abierto' THEN 1
        END
    ) AS cantidad_abiertos,
    COUNT(
        CASE
            WHEN incidentes.estado = 'Resuelto' THEN 1
        END
    ) AS cantidad_resueltos,
    COUNT(
        CASE
            WHEN incidentes.estado = 'En análisis' THEN 1
        END
    ) AS cantidad_en_analisis
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
GROUP BY sucursales.nombre;

-- Total incidents and open incidents by branch

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS incidentes_totales,
    COUNT(
        CASE
            WHEN incidentes.estado = 'Abierto' THEN 1
        END
    ) AS incidentes_abiertos
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
GROUP BY sucursales.nombre
HAVING incidentes_totales > 2
ORDER BY incidentes_totales DESC;

-- =========================================
-- DATE QUERIES
-- =========================================

-- Incidents from October 2026 onwards

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad_incidentes
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
WHERE incidentes.fecha_creacion >= '2026-10-01'
GROUP BY sucursales.nombre
ORDER BY cantidad_incidentes DESC;

-- Incidents between September 15 and September 30, 2026

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS cantidad
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
WHERE incidentes.fecha_creacion >= '2026-09-15 00:00:00'
AND incidentes.fecha_creacion < '2026-10-01 00:00:00'
GROUP BY sucursales.nombre
ORDER BY cantidad DESC;

-- Incidents per day during September 2026

SELECT
    DATE(incidentes.fecha_creacion) AS fecha,
    COUNT(incidentes.id) AS cantidad
FROM incidentes
WHERE incidentes.fecha_creacion >= '2026-09-01'
AND incidentes.fecha_creacion < '2026-10-01'
GROUP BY DATE(incidentes.fecha_creacion)
ORDER BY DATE(incidentes.fecha_creacion) ASC;

-- Incidents per month

SELECT
    MONTH(incidentes.fecha_creacion) AS Mes,
    COUNT(incidentes.id) AS Cantidad_de_Incidentes
FROM incidentes
GROUP BY Mes
ORDER BY Mes ASC;

-- Month name and incident count

SELECT
    CASE
        WHEN MONTH(incidentes.fecha_creacion) = 9 THEN 'Septiembre'
        WHEN MONTH(incidentes.fecha_creacion) = 10 THEN 'Octubre'
    END AS Mes,
    COUNT(incidentes.id) AS Cantidad_de_Incidentes
FROM incidentes
GROUP BY Mes, MONTH(incidentes.fecha_creacion)
HAVING Mes IS NOT NULL
ORDER BY MONTH(incidentes.fecha_creacion);

-- Incident status counts by month

SELECT
    CASE
        WHEN MONTH(incidentes.fecha_creacion) = 9 THEN 'Septiembre'
        WHEN MONTH(incidentes.fecha_creacion) = 10 THEN 'Octubre'
    END AS Mes,
    COUNT(
        CASE
            WHEN incidentes.estado = 'Abierto' THEN 1
        END
    ) AS Abierto,
    COUNT(
        CASE
            WHEN incidentes.estado = 'Resuelto' THEN 1
        END
    ) AS Resuelto,
    COUNT(
        CASE
            WHEN incidentes.estado = 'En análisis' THEN 1
        END
    ) AS En_analisis
FROM incidentes
GROUP BY Mes, MONTH(incidentes.fecha_creacion)
HAVING Mes IS NOT NULL
ORDER BY MONTH(incidentes.fecha_creacion);

-- Incidents by year and month

SELECT
    YEAR(incidentes.fecha_creacion) AS Anio,
    MONTH(incidentes.fecha_creacion) AS Mes,
    COUNT(incidentes.id) AS Cantidad_incidentes
FROM incidentes
GROUP BY Anio, Mes
ORDER BY Anio, Mes ASC;

-- Incidents by branch during September 2026

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS Cantidad
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
WHERE YEAR(incidentes.fecha_creacion) = 2026
AND MONTH(incidentes.fecha_creacion) = 9
GROUP BY sucursales.nombre
ORDER BY Cantidad DESC;

-- =========================================
-- RANKINGS / LIMIT
-- =========================================

-- Top 3 branches by incidents during October 2026

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS Cantidad
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
WHERE YEAR(incidentes.fecha_creacion) = 2026
AND MONTH(incidentes.fecha_creacion) = 10
GROUP BY sucursales.nombre
ORDER BY Cantidad DESC
LIMIT 3;

-- Top 5 incident categories

SELECT
    incidentes.categoria AS Categoria,
    COUNT(incidentes.id) AS Cantidad
FROM incidentes
GROUP BY incidentes.categoria
ORDER BY Cantidad DESC
LIMIT 5;

-- High-priority incidents by branch during September 2026

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS Cantidad
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
WHERE incidentes.prioridad = 'Alta'
AND incidentes.fecha_creacion >= '2026-09-01'
AND incidentes.fecha_creacion < '2026-10-01'
GROUP BY sucursales.nombre
HAVING Cantidad >= 2
ORDER BY Cantidad DESC;

-- Top 3 CABA branches with high-priority incidents during September 2026

SELECT
    sucursales.nombre,
    COUNT(incidentes.id) AS Cantidad
FROM sucursales
JOIN incidentes
ON sucursales.id = incidentes.sucursal_id
WHERE sucursales.provincia = 'CABA'
AND incidentes.prioridad = 'Alta'
AND incidentes.fecha_creacion >= '2026-09-01'
AND incidentes.fecha_creacion < '2026-10-01'
GROUP BY sucursales.nombre
HAVING Cantidad >= 2
ORDER BY Cantidad DESC
LIMIT 3;
