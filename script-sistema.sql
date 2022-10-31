--Script para la implementación de la base de datos del sistema

--Tablas que no tienen ninguna relacion

--Tabla cliente

CREATE TABLE cliente (
        id_cliente SERIAL PRIMARY KEY,
        nombre VARCHAR(45),
        telefono INT,
        correo VARCHAR(50),
        direccion VARCHAR(100),
        estado SMALLINT,
        nit INT
    );
     
---Tabla tipo comprobante

CREATE TABLE tipo_comprobante(
        id_tipo_comprobante SERIAL PRIMARY KEY,
        nombre VARCHAR(45)
    );

--Tabla modo pago

CREATE TABLE modo_pago(
        id_modo_pago SERIAL PRIMARY KEY,
        nombre VARCHAR(45)
    );

--Tabla tipo de servicio

CREATE TABLE
     tipo_servicio(
        id_tipo_servicio SERIAL PRIMARY KEY,
        nombre VARCHAR(45)
    );

--Tabla proveedor

CREATE TABLE   proveedor(
        id_proveedor SERIAL PRIMARY KEY,
        nombre VARCHAR(45),
        telefono INT,
        direccion VARCHAR(60),
        correo VARCHAR(45)
    );

--Tabla rol

CREATE TABLE rol(
        id_rol SERIAL PRIMARY KEY,
        nombre VARCHAR(45)
    );

--Tabla usuario

CREATE TABLE usuario(
        id_usuario SERIAL PRIMARY KEY,
        nombre VARCHAR(45),
        apellido VARCHAR(45),
        tipo_usuario VARCHAR(45),
        email VARCHAR(45),
        puesto VARCHAR(45),
        telefono INT,
        usuario_password VARCHAR(255),
        id_rol INT,
        FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
    );

--Tabla tipo de materia prima

CREATE TABLE tipo_materia_prima(
        id_tipo_materia SERIAL PRIMARY KEY,
        nombre VARCHAR(45)
    );

--Tabla factura

CREATE TABLE factura(
        id_factura SERIAL PRIMARY KEY,
        observaciones TEXT,
        fecha DATE
    );

--Tabla unidad de medida

CREATE TABLE unidad_de_medida(
        id_unidad_medida SERIAL PRIMARY KEY,
        nombre VARCHAR(45)
    );

--Tabla tipo de empaque

CREATE TABLE
    tipo_empaque(
        id_tipo_empaque SERIAL PRIMARY KEY,
        nombre VARCHAR(45)
    );

--Tabla tipo producto

CREATE TABLE
    tipo_producto(
        id_tipo_producto SERIAL PRIMARY KEY,
        nombre VARCHAR(45)
    );

--Tabla servicio café

CREATE TABLE   servicio_cafe(
        id_servicio_cafe SERIAL PRIMARY KEY,
        fecha DATE,
        costo_servicio DOUBLE PRECISION,
        id_tipo_materia INT,
        id_tipo_servicio INT,
        id_unidad_medida INT,
        FOREIGN KEY (id_tipo_materia) REFERENCES tipo_materia_prima(id_tipo_materia),
        FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio),
        FOREIGN KEY (id_unidad_medida) REFERENCES unidad_de_medida(id_unidad_medida)
    );

--Tabla modulo

CREATE TABLE   modulo(
        id_modulo SERIAL PRIMARY KEY,
        nombre VARCHAR(45)
    );

--Tabla transportista

CREATE TABLE transportista(
        id_transportista SERIAL PRIMARY KEY,
        nombre VARCHAR(45),
        telefono INT,
        direccion VARCHAR(100),
        email VARCHAR(45),
        observaciones TEXT,
        tarifa DOUBLE PRECISION
    );

--Tablas con relaciones con las tablas anteriores

--Tabla costo de produccion

CREATE TABLE costo_produccion(
        id_costo_produccion SERIAL PRIMARY KEY,
	    fecha DATE,
        cantidad INT,
        precio_venta DOUBLE PRECISION,
        costo_por_libra DOUBLE PRECISION,
        ganancia_neta DOUBLE PRECISION,
        id_empaque INT,
        id_materia_prima INT,
        id_unidad_medida INT,
        id_servicio_cafe INT,
        FOREIGN KEY (id_empaque) REFERENCES material_empaque(id_empaque),
        FOREIGN KEY (id_materia_prima) REFERENCES materia_prima(id_materia_prima),
        FOREIGN KEY (id_unidad_medida) REFERENCES unidad_de_medida(id_unidad_medida),
        FOREIGN KEY (id_servicio_cafe) REFERENCES servicio_cafe(id_servicio_cafe)
    );

--Tabla de Producto

CREATE TABLE producto(
        id_producto SERIAL PRIMARY KEY,
        nombre VARCHAR(45),
        stock_ingreso INT,
        id_unidad_medida INT,
        tipo_producto INT,
        stock_actual INT,
        precio_venta DOUBLE PRECISION,
        stock_minimo INT,
        id_costo_produccion INT,
        FOREIGN KEY (id_unidad_medida) REFERENCES unidad_de_medida(id_unidad_medida),
        FOREIGN KEY (tipo_producto) REFERENCES tipo_producto(id_tipo_producto),
        FOREIGN KEY (id_costo_produccion) REFERENCES costo_produccion(id_costo_produccion)
    );

--Tabla de Compra

CREATE TABLE compras(
        id_compra SERIAL PRIMARY KEY,
        fecha DATE,
        cantidad INT,
        precio_unitario DOUBLE PRECISION,
        descuento DOUBLE PRECISION,
        subtotal DOUBLE PRECISION,
        total DOUBLE PRECISION,
        no_comprobante INT,
        observaciones VARCHAR(45),
        id_tipo_comprobante INT,
        id_proveedor INT,
        id_producto INT,
        id_modo_pago INT,
        id_usuario INT,
        FOREIGN KEY (id_tipo_comprobante) REFERENCES tipo_comprobante(id_tipo_comprobante),
        FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
        FOREIGN KEY (id_modo_pago) REFERENCES modo_pago(id_modo_pago),
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
    );

--Tabla venta

CREATE TABLE venta(
        id_venta SERIAL PRIMARY KEY,
        fecha DATE,
        cantidad INT,
        descripcion VARCHAR(45),
        descuento DOUBLE PRECISION,
        subtotal DOUBLE PRECISION,
        total DOUBLE PRECISION,
        id_factura INT,
        id_cliente INT,
        id_producto INT,
        id_modo_pago INT,
        id_usuario INT,
        FOREIGN KEY (id_factura) REFERENCES factura(id_factura),
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
        FOREIGN KEY (id_modo_pago) REFERENCES modo_pago(id_modo_pago),
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
    );

--Tabla pedido cliente

CREATE TABLE pedido_cliente(
        id_pedido_cliente SERIAL PRIMARY KEY,
        fecha DATE,
        cantidad_producto VARCHAR(45),
        descuento DOUBLE PRECISION,
        total DOUBLE PRECISION,
        id_cliente INT,
        id_usuario INT,
        id_producto INT,
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
    );

--Inventario_movimientos

--Se modifico la tabla

CREATE TABLE
    inventario_movimiento(
        id_inventario_movimiento SERIAL PRIMARY KEY,
        fecha TIMESTAMP,
        tipo_operacion VARCHAR(45),
        decuento DOUBLE PRECISION,
        total_operacion DOUBLE PRECISION,
        id_venta INT,
        id_compra INT,
        id_usuario INT,
        id_cliente INT,
        id_proveedor INT,
        id_modo_pago INT,
        FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
        FOREIGN KEY (id_compra) REFERENCES compras(id_compra),
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
        FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
        FOREIGN KEY (id_modo_pago) REFERENCES modo_pago(id_modo_pago)
    );

--Tabla operacion

CREATE TABLE operacion(
        id_operacion SERIAL PRIMARY KEY,
        id_modulo INT,
        FOREIGN KEY (id_modulo) REFERENCES modulo(id_modulo)
    );

--Tabla rol operacion

CREATE TABLE rol_operacion(
        id_rol_operacion SERIAL PRIMARY KEY,
        id_rol INT,
        id_operacion INT,
        FOREIGN KEY (id_rol) REFERENCES rol(id_rol),
        FOREIGN KEY (id_operacion) REFERENCES operacion(id_operacion)
    );

--Devolución proveedor

CREATE TABLE devolucion_proveedor(
        id_devolucion_proveedor SERIAL PRIMARY KEY,
        fecha DATE,
        detalle_devolucion VARCHAR(45),
        sub_total DOUBLE PRECISION,
        total DOUBLE PRECISION,
        id_transportista INT,
        id_compra INT,
        FOREIGN KEY (id_transportista) REFERENCES transportista(id_transportista),
        FOREIGN KEY (id_compra) REFERENCES compras(id_compra)
    );

--Devolucion cliente

CREATE TABLE devolucion_cliente(
        id_dev_cliente SERIAL PRIMARY KEY,
        fecha DATE,
        detalle_devolucion VARCHAR(45),
        sub_total DOUBLE PRECISION,
        total DOUBLE PRECISION,
        id_venta INT,
        id_transportista INT,
        id_cliente INT,
        id_usuario INT,
        FOREIGN KEY(id_venta) REFERENCES venta(id_venta),
        FOREIGN KEY(id_transportista) REFERENCES transportista(id_transportista),
        FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente),
        FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario)
    );

--Materia Prima

CREATE TABLE materia_prima(
        id_materia_prima SERIAL PRIMARY KEY,
        cantidad DOUBLE PRECISION,
        costo DOUBLE PRECISION,
        id_unidad_medida INT,
        id_tipo_materia INT,
        fecha DATE,
        FOREIGN KEY(id_unidad_medida) REFERENCES unidad_de_medida(id_unidad_medida),
        FOREIGN KEY(id_tipo_materia) REFERENCES tipo_materia_prima(id_tipo_materia)
    );

--Tabla Material de Empaque

CREATE TABLE material_empaque(
        id_empaque SERIAL PRIMARY KEY,
        fecha DATE,
        costo_empaque DOUBLE PRECISION,
        id_tipo_empaque INT,
        FOREIGN KEY (id_tipo_empaque) REFERENCES tipo_empaque(id_tipo_empaque)
    );
