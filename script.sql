
CREATE TABLE DIM_CLIENTE (
    cliente_key SERIAL PRIMARY KEY,
    id_cliente VARCHAR(20),
    genero VARCHAR(10),
    edad INT,
    rango_edad VARCHAR(20)
);

CREATE TABLE DIM_PRODUCTO (
    producto_key SERIAL PRIMARY KEY,
    categoria VARCHAR(100)
);

CREATE TABLE DIM_FECHA (
    fecha_key SERIAL PRIMARY KEY,
    fecha_completa DATE,
    dia INT,
    mes INT,
    anio INT
);

CREATE TABLE DIM_METODO_PAGO (
    metodo_pago_key SERIAL PRIMARY KEY,
    metodo_pago VARCHAR(50)
);

CREATE TABLE DIM_CENTRO_COMERCIAL (
    centro_comercial_key SERIAL PRIMARY KEY,
    nombre_centro_comercial VARCHAR(100)
);

-- CREACIÓN DE TABLA DE HECHOS

CREATE TABLE HECHO_VENTAS (
    id_venta SERIAL PRIMARY KEY,
    numero_factura VARCHAR(50),

    cliente_key INT,
    producto_key INT,
    fecha_key INT,
    centro_comercial_key INT,
    metodo_pago_key INT,

    cantidad INT,
    monto_total NUMERIC(10,2),

    FOREIGN KEY (cliente_key) 
        REFERENCES DIM_CLIENTE(cliente_key),

    FOREIGN KEY (producto_key) 
        REFERENCES DIM_PRODUCTO(producto_key),

    FOREIGN KEY (fecha_key) 
        REFERENCES DIM_FECHA(fecha_key),

    FOREIGN KEY (centro_comercial_key) 
        REFERENCES DIM_CENTRO_COMERCIAL(centro_comercial_key),

    FOREIGN KEY (metodo_pago_key) 
        REFERENCES DIM_METODO_PAGO(metodo_pago_key)
);