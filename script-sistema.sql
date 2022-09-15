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

--Tabla tipo comprobante
CREATE TABLE tipo_comprobante(
	id_tipo_comprobante SERIAL PRIMARY KEY,
	nombre VARCHAR(45)
);

--Tabla modo pago
CREATE TABLE modo_pago(
	id_modo_pago SERIAL PRIMARY KEY,
	nombre VARCHAR(45)
);

--Tabla proveedor
CREATE TABLE proveedor(
	id_proveedor SERIAL PRIMARY KEY,
	nombre VARCHAR(45),
	telefono INT,
	direccion VARCHAR(60),
	correo VARCHAR(45)
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
CREATE TABLE tipo_empaque(
	id_empaque SERIAL PRIMARY KEY,
	nombre VARCHAR(45)
);

--Tabla tipo producto
CREATE TABLE tipo_producto(
	id_tipo_producto SERIAL PRIMARY KEY,
	nombre VARCHAR(45)
);

--Tabla rol
CREATE TABLE rol(
	id_rol SERIAL PRIMARY KEY, 
	nombre VARCHAR(45)
);

--Tabla modulo
CREATE TABLE modulo(
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

--Tabla tipo de servicio
CREATE TABLE tipo_servicio(
	id_tipo_servicio SERIAL PRIMARY KEY,
	nombre VARCHAR(45)
);

--Tabla tipo de materia prima
CREATE TABLE tipo_materia_prima(
	id_tipo_materia SERIAL PRIMARY KEY,
	nombre VARCHAR(45)
);

--Tablas con relaciones con las tablas anteriores
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
	id_operacion INT.
	FOREIGN KEY (id_rol) REFERENCES rol(id-rol),
	FOREIGN KEY (id_operacion) REFERENCES operacion(id_operacion)
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
	usuario_password VARCHAR(40),
	id_rol INT,
	FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

--Tabla servicio café
CREATE TABLE servicio_cafe(
	id_servicio_cafe SERIAL PRIMARY KEY,
	fecha DATE,
	costo_servicio DOUBLE PRECISION,
	id_tipo_materia INT,
	id_tipo_servicio INT,
	id_unidad_medida INT,
	FOREIGN KEY (id_tipo_materia) REFERENCES tipo_materia_prima(id_tipo_materia),
	FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio)
	FOREIGN KEY (id_unidad_medida) REFERENCES unidad_de_medida(id_unidad_medida)
);

--Tabla costo producción
CREATE TABLE costo_produccion(
	id_costo_produccion SERIAL PRIMARY KEY,
	cantidad INT,
	precio_venta DOUBLE PRECISION,
	costo_por_libra DOUBLE PRECISION,
	ganancia_neta DOUBLE PRECISION,
	id_empaque INT,
	id_tipo_materia INT,
	id_unidad_medida INT,
	id_servicio_cafe INT,
	FOREIGN KEY (id_empaque) REFERENCES tipo_empaque(id_empaque),
	FOREIGN KEY (id_tipo_materia) REFERENCES tipo_materia_prima(id_tipo_materia)
	FOREIGN KEY (id_unidad_medida) REFERENCES unidad_de_medida(id_unidad_medida)
	FOREIGN KEY (id_servicio_cafe) REFERENCES servicio_cafe(id_servicio_cafe)
);