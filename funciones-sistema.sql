--Funcion para obtener todas las ventas

CREATE OR REPLACE FUNCTION GETALLSALES() RETURNS TABLE
(ID_VENTA INTEGER, FECHA DATE, CANTIDAD INTEGER, PRECIO_UNI 
DOUBLE PRECISION, UNIDAD_MEDIDA CHARACTER VARYING, 
DESCRIPCION CHARACTER VARYING, DESCUENTO DOUBLE PRECISION
, SUBTOTAL DOUBLE PRECISION, TOTAL DOUBLE PRECISION
, CLIENTE CHARACTER VARYING, FACTURA INTEGER, PRODUCTO 
CHARACTER VARYING, MODO_PAGO CHARACTER VARYING, USUARIO 
CHARACTER VARYING) AS 
	$$ BEGIN
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

$$ LANGUAGE 'plpgsql';

--Ejemplo de ejecución de la función

select * from getAllSales();

--Funcion para obtener una venta en especifico

CREATE OR REPLACE FUNCTION GETSALE(ID_V INTEGER) RETURNS 
TABLE(ID_VENTA INTEGER, FECHA DATE, CANTIDAD INTEGER
, PRECIO_UNI DOUBLE PRECISION, UNIDAD_MEDIDA CHARACTER 
VARYING, DESCRIPCION CHARACTER VARYING, DESCUENTO 
DOUBLE PRECISION, SUBTOTAL DOUBLE PRECISION, TOTAL 
DOUBLE PRECISION, CLIENTE CHARACTER VARYING, FACTURA 
INTEGER, PRODUCTO CHARACTER VARYING, MODO_PAGO CHARACTER 
VARYING, USUARIO CHARACTER VARYING) AS 
	$$ BEGIN
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

$$ LANGUAGE 'plpgsql';

--Ejemplo de uso de la funcion con el id 2

select * from getsale(2);

--Funcion para insertar datos a la tabla venta

CREATE OR REPLACE FUNCTION INSERTSALE(CANTIDAD INTEGER
, DESCRIPCION CHARACTER VARYING, DESCUENTO DOUBLE 
PRECISION, FACTURA INTEGER, CLIENTE INTEGER, PRODUCTO 
INTEGER, MODO_PAGO INTEGER, USUARIO INTEGER) RETURNS 
VOID AS 
	$$ DECLARE fechaActual DATE = (SELECT CURRENT_DATE);
	precio_venta DOUBLE PRECISION = (
	    SELECT precio_venta
	    FROM producto
	    WHERE id_producto = $6
	);
	subtotal DOUBLE PRECISION;
	total DOUBLE PRECISION = 0;
	BEGIN subtotal = precio_venta * cantidad;
	total = subtotal - descuento;
	INSERT INTO
	    venta(
	        fecha,
	        cantidad,
	        descripcion,
	        descuento,
	        subtotal,
	        total,
	        id_factura,
	        id_cliente,
	        id_producto,
	        id_modo_pago,
	        id_usuario
	    )
	VALUES
	(
	        fechaActual,
	        cantidad,
	        descripcion,
	        descuento,
	        subtotal,
	        total,
	        factura,
	        cliente,
	        producto,
	        modo_pago,
	        usuario
	    );
END; 

$$ LANGUAGE 'plpgsql';

--Ejemplo de uso de la funcion

--insertSale(cantidad, descrpcion, descuento, id_factura. id_cliente, id_producto, id_modo_pago, id_usuario)

SELECT insertSale(1, 'Insert cafe prueba', 5, 1, 1, 2, 2, 2);

--Funcion para actualizar datos de una venta

CREATE OR REPLACE FUNCTION UPDATESALE(ID_V INTEGER, 
CANTIDAD INTEGER, DESCRIPCION CHARACTER VARYING, DESCUENTO 
DOUBLE PRECISION, FACTURA INTEGER, CLIENTE INTEGER
, PRODUCTO INTEGER, MODO_PAGO INTEGER, USUARIO INTEGER
) RETURNS VOID AS 
	$$ DECLARE fechaActual DATE = (SELECT CURRENT_DATE);
	precio_venta DOUBLE PRECISION = (
	    SELECT precio_venta
	    FROM producto
	    WHERE id_producto = $7
	);
	subtotalCalculado DOUBLE PRECISION;
	totalCalculado DOUBLE PRECISION = 0;
	BEGIN subtotalCalculado = precio_venta * cantidad;
	totalCalculado = subtotalCalculado - descuento;
	UPDATE venta
	SET
	    fecha = fechaActual,
	    cantidad = $2,
	    descripcion = $3,
	    descuento = $4,
	    subtotal = subtotalCalculado,
	    total = totalCalculado,
	    id_factura = $5,
	    id_cliente = $6,
	    id_producto = $7,
	    id_modo_pago = $8,
	    id_usuario = $9
	WHERE id_venta = id_v;
END; 

$$ LANGUAGE 'plpgsql';

--updateSale(id_v, cantidad, descrpcion, descuento, id_factura. id_cliente, id_producto, id_modo_pago, id_usuario)

SELECT updateSale(10, 2, 'CAFE Prueba', 10, 1, 1, 2, 2, 2);

--Funcion para llenar la tabla inventario_movimiento

CREATE OR REPLACE FUNCTION SP_TR_INSER_VENTA_INSERT_LOG_MOV_INVENTARIO
() RETURNS TRIGGER AS 
	$$ BEGIN
	INSERT INTO
	    inventario_movimiento(
	        fecha,
	        tipo_operacion,
	        descuento,
	        total_operacion,
	        id_venta,
	        id_usuario,
	        id_cliente,
	        id_modo_pago
	    )
	VALUES (
	        new.fecha,
	        'Venta',
	        new.descuento,
	        new.total,
	        new.id_venta,
	        new.id_usuario,
	        new.id_cliente,
	        new.id_modo_pago
	    );
	RETURN NEW;
	END 
$ 

$ LANGUAGE plpgsql;

--Trigger que se dispara despues del insert en la tabla venta

CREATE TRIGGER TR_INSERT_LOG_MOV_INVENTARIO AFTER INSERT 
ON VENTA FOR EACH ROW EXECUTE PROCEDURE SP_TR_INSER_VENTA_INSERT_LOG_MOV_INVENTARIO
() ; -- FUNCION PARA DEJAR CONTANCIA EN MOVIMIENTO INVENTARIO DE LA COMPRA 
CREATE OR REPLACE FUNCTION SP_TR_INSER_COMPRA_INSERT_LOG_MOV_INVENTARIO
() RETURNS TRIGGER AS 
	$$ BEGIN
	INSERT INTO
	    inventario_movimiento(
	        fecha,
	        tipo_operacion,
	        descuento,
	        total_operacion,
	        id_compra,
	        id_usuario,
	        id_proveedor,
	        id_modo_pago
	    )
	VALUES (
	        new.fecha,
	        'Compra',
	        new.descuento,
	        new.total,
	        new.id_compra,
	        new.id_usuario,
	        new.id_proveedor,
	        new.id_modo_pago
	    );
	RETURN NEW;
	END 
$ 

$ LANGUAGE plpgsql;

--Trigger que se dispara despues del insert enn la tabla compras

CREATE TRIGGER TR2_INSERT_LOG_MOV_INVENTARIO AFTER 
INSERT ON COMPRAS FOR EACH ROW EXECUTE PROCEDURE SP_TR_INSER_COMPRA_INSERT_LOG_MOV_INVENTARIO
() ; --FUNCION PARA INSERTAR PRODUCTO 
CREATE OR REPLACE FUNCTION INSERTPRODUCT(NOMBRE CHARACTER 
VARYING, STOCK_INGRESO INTEGER, UNIDAD_MEDIDA INTEGER
, TIPO_PRODUCTO INTEGER, PRECIO_VENT DOUBLE PRECISION
, STOCK_MINIMO INTEGER) RETURNS VOID AS 
	$$ DECLARE id_cost_producc INTEGER;
	BEGIN id_cost_producc = (
	    select id_costo_produccion
	    FROM costo_produccion
	    WHERE id_costo_produccion = (
	            SELECT
	                MAX(id_costo_produccion)
	            FROM costo_produccion
	        )
	);
	INSERT INTO
	    producto(
	        nombre,
	        stock_ingreso,
	        id_unidad_medida,
	        tipo_producto,
	        stock_actual,
	        precio_venta,
	        stock_minimo,
	        id_costo_produccion
	    )
	VALUES
	(
	        $1,
	        $2,
	        $3,
	        $4,
	        $2,
	        $5,
	        $6,
	        id_cost_producc
	    );
END; 

$$ LANGUAGE 'plpgsql';

--Ejemplo de uso

select insertproduct('Func prueba Cafe 2', 10, 1, 1, 12, 10);

--Funcion para actualizar producto

CREATE OR REPLACE FUNCTION UPDATEPRODUCT(ID_PRODUCT 
INTEGER, NOMBRE CHARACTER VARYING, STOCK_INGRESO INTEGER
, UNIDAD_MEDIDA INTEGER, TIPO_PRODUCTO INTEGER, PRECIO_VENT 
DOUBLE PRECISION, STOCK_MINIMO INTEGER) RETURNS VOID 
AS 
	$$ DECLARE id_cost_producc INTEGER;
	stock_act INTEGER;
	stock_aux INTEGER;
	BEGIN stock_act = (
	    SELECT stock_actual
	    FROM producto
	    WHERE id_producto = $1
	);
	id_cost_producc = (
	    select id_costo_produccion
	    FROM costo_produccion
	    WHERE id_costo_produccion = (
	            SELECT
	                MAX(id_costo_produccion)
	            FROM costo_produccion
	        )
	);
	stock_aux = stock_act + $3;
	UPDATE producto
	SET
	    nombre = $2,
	    stock_ingreso = $3,
	    id_unidad_medida = $4,
	    tipo_producto = $5,
	    stock_actual = stock_aux,
	    precio_venta = $6,
	    stock_minimo = $7,
	    id_costo_produccion = id_cost_producc
	WHERE id_producto = id_product;
END; 

$$ LANGUAGE 'plpgsql';

--Ejemplo de uso

select
    updateProduct(
        14,
        'prueba func desde backend2',
        20,
        2,
        1,
        25,
        5
    );