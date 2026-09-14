USE Ventas_Tech_DB;

SELECT * FROM ventas;
 
-- Consulta 1 Resumen ejecutivo mensual --

SELECT
MONTH(fecha_venta) AS mes,
SUM (Cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS cantidad_pedidos,
AVG(cantidad * precio_unitario)/ COUNT (*) AS ticket_promedio
FROM ventas
GROUP BY MONTH (fecha_venta) 
ORDER BY mes;

-- Consulta 2 Ranking de productos --

SELECT id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM (cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

--Consulta 3 Clientes recurrentes --

SELECT id_cliente, COUNT(*) AS cantidad_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas GROUP BY id_cliente HAVING COUNT(*) >1
ORDER BY total_gastado DESC;

-- Consulta 4 Meses por encima / por debajo del promedio --

SELECT
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
CASE WHEN SUM(cantidad * precio_unitario) > (SELECT AVG(total_mes) FROM (SELECT SUM(cantidad * precio_unitario) AS total_mes
FROM ventas
GROUP BY MONTH(fecha_venta)) AS totales_por_mes) THEN 'Por encima' ELSE 'Por debajo'
END AS comparacion_promedio FROM ventas 
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- Hallazgos--
-- 1. El producto 1 concreta el 56% de la facturacion total ($3600 de $64444,
-- a pesar de haber vendido solo 3 unidades: es el que tiene mayor precio unitario ($1200), no el que mas rota.

-- 2. Los 5 clientes registrados en la tabla son recurrentes: todos hiceiron exactamente 2 pedidos.
--El cliente 1 es el que mas gasto en total ($2640), seguido de cerca por el cliente 5 ($2100).

-- 3. El producrto 2 es el que mas unidades vendio (13 en total, entre los pedidos 2 y 8), pero es el que menos factura enter el Top 5 ($364)
-- Tiene el precio unitario mas bajo ($28), asi que vender mucho volumen no significa necesariamente generar mucha facturacion.