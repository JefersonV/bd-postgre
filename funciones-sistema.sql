--Funcion para obtener todas las ventas
CREATE OR REPLACE FUNCTION getAllSales()
RETURNS
    TABLE(
        id_venta INTEGER,
        fecha DATE,
        cantidad INTEGER,
		precio_uni DOUBLE PRECISION,
		unidad_medida CHARACTER VARYING,
        descripcion CHARACTER VARYING,
        descuento DOUBLE PRECISION,
        subtotal DOUBLE PRECISION,
        total DOUBLE PRECISION,
        cliente CHARACTER VARYING,
        factura INTEGER,
        producto  CHARACTER VARYING,
		modo_pago CHARACTER VARYING,
        usuario CHARACTER VARYING
    )
AS $$
BEGIN
    RETURN QUERY
    SELECT
            venta.id_venta,
            venta.fecha,
            venta.cantidad,
			producto.precio_venta,
            venta.descripcion,
			unidad_de_medida.nombre,
            venta.descuento,
            venta.subtotal,
            venta.total,
            cliente.nombre,
            factura.id_factura,
            producto.nombre,
            modo_pago.nombre,
            usuario.nombre
        FROM venta
            INNER JOIN cliente ON cliente.id_cliente = venta.id_cliente
            INNER JOIN factura ON factura.id_factura = venta.id_factura
            INNER JOIN producto ON producto.id_producto = venta.id_producto
            INNER JOIN modo_pago ON modo_pago.id_modo_pago = venta.id_modo_pago
            INNER JOIN usuario ON usuario.id_usuario = venta.id_usuario
			INNER JOIN unidad_de_medida ON unidad_de_medida.id_unidad_medida = producto.id_unidad_medida;
END;
$$
LANGUAGE 'plpgsql';

--Ejemplo de ejecución de la función
select * from getAllSales();

--Funcion para obtener una venta en especifico 
CREATE OR REPLACE FUNCTION getSale(id_v INTEGER)
RETURNS
    TABLE(
        id_venta INTEGER,
        fecha DATE,
        cantidad INTEGER,
		precio_uni DOUBLE PRECISION,
		unidad_medida CHARACTER VARYING,
        descripcion CHARACTER VARYING,
        descuento DOUBLE PRECISION,
        subtotal DOUBLE PRECISION,
        total DOUBLE PRECISION,
        cliente CHARACTER VARYING,
        factura INTEGER,
        producto  CHARACTER VARYING,
		modo_pago CHARACTER VARYING,
        usuario CHARACTER VARYING
    )
AS $$
BEGIN
    RETURN QUERY
    SELECT
            venta.id_venta,
            venta.fecha,
            venta.cantidad,
			producto.precio_venta,
            venta.descripcion,
			unidad_de_medida.nombre,
            venta.descuento,
            venta.subtotal,
            venta.total,
            cliente.nombre,
            factura.id_factura,
            producto.nombre,
            modo_pago.nombre,
            usuario.nombre
        FROM venta
            INNER JOIN cliente ON cliente.id_cliente = venta.id_cliente
            INNER JOIN factura ON factura.id_factura = venta.id_factura
            INNER JOIN producto ON producto.id_producto = venta.id_producto
            INNER JOIN modo_pago ON modo_pago.id_modo_pago = venta.id_modo_pago
            INNER JOIN usuario ON usuario.id_usuario = venta.id_usuario
            INNER JOIN unidad_de_medida ON unidad_de_medida.id_unidad_medida = producto.id_unidad_medida
		WHERE venta.id_venta = id_v;
END;
$$
LANGUAGE 'plpgsql';
--Ejemplo de uso de la funcion con el id 2
select * from getsale(2);

--Funcion para insertar datos a la tabla venta
CREATE OR REPLACE FUNCTION insertSale(
        cantidad INTEGER,
        descripcion CHARACTER VARYING,
        descuento DOUBLE PRECISION,
		factura INTEGER,
        cliente INTEGER,
        producto  INTEGER,
		modo_pago INTEGER,
        usuario INTEGER
) RETURNS VOID AS
$$
DECLARE
	fechaActual DATE = (SELECT CURRENT_DATE);
	precio_venta DOUBLE PRECISION = (SELECT precio_venta FROM producto WHERE id_producto = $6);
    subtotal DOUBLE PRECISION;
	total DOUBLE PRECISION = 0;
BEGIN
	subtotal = precio_venta * cantidad;
	total = subtotal - descuento;
	INSERT INTO venta(fecha, cantidad, descripcion, descuento, subtotal, total, id_factura, id_cliente, id_producto, id_modo_pago, id_usuario)
	VALUES(fechaActual, cantidad, descripcion, descuento, subtotal, total, factura, cliente, producto, modo_pago, usuario);
END;
$$
LANGUAGE 'plpgsql';

--Ejemplo de uso de la funcion
--insertSale(cantidad, descrpcion, descuento, id_factura. id_cliente, id_producto, id_modo_pago, id_usuario)
SELECT insertSale(1, 'Insert cafe prueba', 5, 1, 1, 2, 2, 2);


--Funcion para actualizar datos de una venta
CREATE OR REPLACE FUNCTION updateSale(
	id_v INTEGER,
    cantidad INTEGER,
    descripcion CHARACTER VARYING,
    descuento DOUBLE PRECISION,
	factura INTEGER,
    cliente INTEGER,
    producto  INTEGER,
	modo_pago INTEGER,
    usuario INTEGER
) RETURNS VOID AS
$$
DECLARE
	fechaActual DATE = (SELECT CURRENT_DATE);
	precio_venta DOUBLE PRECISION = (SELECT precio_venta FROM producto WHERE id_producto = $7);
    subtotalCalculado DOUBLE PRECISION;
	totalCalculado DOUBLE PRECISION = 0;
BEGIN
	subtotalCalculado = precio_venta * cantidad;
	totalCalculado = subtotalCalculado - descuento;
	UPDATE venta SET fecha = fechaActual, cantidad = $2, descripcion = $3, descuento = $4, subtotal  = subtotalCalculado, total = totalCalculado,id_factura = $5, id_cliente = $6, id_producto = $7, id_modo_pago = $8, id_usuario = $9
	WHERE id_venta = id_v;
	
END;
$$
LANGUAGE 'plpgsql';

--updateSale(id_v, cantidad, descrpcion, descuento, id_factura. id_cliente, id_producto, id_modo_pago, id_usuario)
SELECT updateSale(10, 2, 'CAFE Prueba', 10, 1, 1, 2, 2, 2);

--Funcion para llenar la tabla inventario_movimiento
CREATE FUNCTION sp_tr_inser_venta_insert_log_mov_inventario() RETURNS TRIGGER
AS
$$
BEGIN
INSERT INTO inventario_movimiento(fecha, tipo_operacion, descuento, total_operacion, id_venta) 
VALUES (new.fecha, 'Venta', new.descuento, new.total, new.id_venta);
RETURN NEW;
END
$$
LANGUAGE plpgsql;
--Trigger que se dispara despues del insert en la tabla venta
CREATE TRIGGER tr_insert_log_mov_inventario AFTER INSERT ON venta
FOR EACH ROW
EXECUTE PROCEDURE sp_tr_inser_venta_insert_log_mov_inventario();


-- Funcion para dejar contancia en movimiento inventario de la compra
CREATE FUNCTION sp_tr_inser_compra_insert_log_mov_inventario() RETURNS TRIGGER
AS
$$
BEGIN
INSERT INTO inventario_movimiento(fecha, tipo_operacion, descuento, total_operacion, id_compra) 
VALUES (new.fecha, 'Compra', new.descuento, new.total, new.id_compra);
RETURN NEW;
END
$$
LANGUAGE plpgsql;
--Trigger que se dispara despues del insert enn la tabla compras
CREATE TRIGGER tr2_insert_log_mov_inventario AFTER INSERT ON compras
FOR EACH ROW
EXECUTE PROCEDURE sp_tr_inser_compra_insert_log_mov_inventario();