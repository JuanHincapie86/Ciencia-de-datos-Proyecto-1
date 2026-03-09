-- 1. Total de ventas por categoría de producto
SELECT
    p.categoria AS categoria,
    COUNT(h.id_venta) AS total_transacciones,
    SUM(h.cantidad) AS unidades_vendidas,
    ROUND(SUM(h.monto_total),2) AS total_ventas,
    ROUND(AVG(h.monto_total),2) AS ticket_promedio
FROM HECHO_VENTAS h
JOIN DIM_PRODUCTO p 
    ON h.producto_key = p.producto_key
GROUP BY p.categoria
ORDER BY total_ventas DESC;



-- 2. Clientes con mayor volumen de compras
SELECT
    c.id_cliente AS cliente,
    c.genero,
    c.edad,
    c.rango_edad AS grupo_etario,
    COUNT(h.id_venta) AS num_compras,
    SUM(h.cantidad) AS total_productos,
    ROUND(SUM(h.monto_total),2) AS total_gastado
FROM HECHO_VENTAS h
JOIN DIM_CLIENTE c
    ON h.cliente_key = c.cliente_key
GROUP BY
    c.id_cliente,
    c.genero,
    c.edad,
    c.rango_edad
ORDER BY total_gastado DESC
LIMIT 10;




-- 3. Métodos de pago más utilizados 
SELECT
    mp.metodo_pago,
    COUNT(h.id_venta) AS num_transacciones,
    ROUND(SUM(h.monto_total), 2) AS total_ventas,
    ROUND(AVG(h.monto_total), 2) AS ticket_promedio,
    ROUND(
        100.0 * COUNT(h.id_venta) /
        SUM(COUNT(h.id_venta)) OVER(), 2
    ) AS porcentaje_uso
FROM HECHO_VENTAS h
JOIN DIM_METODO_PAGO mp
    ON h.metodo_pago_key = mp.metodo_pago_key
GROUP BY mp.metodo_pago
ORDER BY num_transacciones DESC;



-- 4. Comparación de ventas por mes
SELECT
    anio,
    mes,
    num_transacciones,
    unidades_vendidas,
    total_ventas,
    ROUND(
        total_ventas - LAG(total_ventas) OVER (ORDER BY anio, mes),
        2
    ) AS variacion_vs_mes_anterior
FROM (
    SELECT
        f.anio,
        f.mes,
        COUNT(h.id_venta) AS num_transacciones,
        SUM(h.cantidad) AS unidades_vendidas,
        ROUND(SUM(h.monto_total),2) AS total_ventas
    FROM HECHO_VENTAS h
    JOIN DIM_FECHA f
        ON h.fecha_key = f.fecha_key
    GROUP BY f.anio, f.mes
) ventas_mensuales
ORDER BY anio, mes;


-- Índices en la tabla de hechos
CREATE INDEX idx_hecho_cliente
ON HECHO_VENTAS(cliente_key);

CREATE INDEX idx_hecho_producto
ON HECHO_VENTAS(producto_key);

CREATE INDEX idx_hecho_fecha
ON HECHO_VENTAS(fecha_key);

CREATE INDEX idx_hecho_metodo_pago
ON HECHO_VENTAS(metodo_pago_key);

CREATE INDEX idx_hecho_centro_comercial
ON HECHO_VENTAS(centro_comercial_key);

-- Índices en dimensiones
CREATE INDEX idx_producto_categoria
ON DIM_PRODUCTO(categoria);

CREATE INDEX idx_fecha_anio_mes
ON DIM_FECHA(anio, mes);

CREATE INDEX idx_metodo_pago
ON DIM_METODO_PAGO(metodo_pago);

CREATE INDEX idx_cliente_rango_edad
ON DIM_CLIENTE(rango_edad);