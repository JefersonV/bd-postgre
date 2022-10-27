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