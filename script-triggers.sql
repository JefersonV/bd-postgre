-- El siguiente trigger tiene la finalidad de actualizar el stock de producto
-- Cuando se inserte una nueva venta

-- Creamos una funcion que se va a dispara con el trigger
CREATE FUNCTION SP_TR_INSERT_VENTA_UPDATE_STOCK_PRODUCT() RETURNS TRIGGER
AS
$$
BEGIN
UPDATE producto set stock_actual = stock_actual-new.cantidad
WHERE id_producto = new.id_producto;
RETURN NEW;
END
$$
LANGUAGE plpgsql;

-- Este es el triger que se dispara luego insertar una venta
CREATE TRIGGER TR_UPDATE_STOCK_PRODUCTO AFTER INSERT ON venta
FOR EACH ROW
EXECUTE PROCEDURE SP_TR_INSERT_VENTA_UPDATE_STOCK_PRODUCT();

-- ------------------------------------------------------------
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

CREATE TRIGGER tr_insert_log_mov_inventario AFTER INSERT ON venta
FOR EACH ROW
EXECUTE PROCEDURE sp_tr_inser_venta_insert_log_mov_inventario();


-- Trigger para dejar contancia en movimiento inventario de la compra
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

CREATE TRIGGER tr2_insert_log_mov_inventario AFTER INSERT ON compras
FOR EACH ROW
EXECUTE PROCEDURE sp_tr_inser_compra_insert_log_mov_inventario();

INSERT INTO venta(fecha, cantidad, descripcion, descuento, subtotal, 
				  total, id_factura, id_producto, id_modo_pago)
VALUES (CURRENT_DATE, 10, 'Prueba para Log', 0, 25, 25, 1, 1, 1);