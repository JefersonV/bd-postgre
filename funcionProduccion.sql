--obtner todo los registros
CREATE OR REPLACE FUNCTION getallProduccion()
RETURNS
     TABLE(
		id_costo_produccion INTEGER,
		 fecha DATE,
		 cantidad INTEGER ,
		 precio_venta DOUBLE PRECISION,
		 ganancia_neta DOUBLE PRECISION ,
		 costo_por_libra DOUBLE PRECISION,
		 unidad_de_medida CHARACTER VARYING, 
		 tipo_empaque CHARACTER VARYING,
		 costo_empaque DOUBLE PRECISION,
		 materia_prima CHARACTER VARYING,
		 costo_materia DOUBLE PRECISION,
		 costo_servicio DOUBLE PRECISION,
		 servicio  CHARACTER VARYING
		 
	 )
AS $$
BEGIN
	RETURN QUERY
	SELECT 
	costo_produccion.id_costo_produccion,
costo_produccion.fecha,
costo_produccion.cantidad,
costo_produccion.precio_venta,
costo_produccion.ganancia_neta ,
costo_produccion.costo_por_libra,
unidad_de_medida.nombre,
tipo_empaque.nombre ,
material_empaque.costo_empaque,
tipo_materia_prima.nombre,
materia_prima.costo,
servicio_cafe.costo_servicio,
tipo_servicio.nombre

	FROM costo_produccion
INNER JOIN materia_prima on materia_prima.id_materia_prima = costo_produccion.id_materia_prima
INNER JOIN material_empaque on material_empaque.id_empaque = costo_produccion.id_empaque
 INNER JOIN servicio_cafe on servicio_cafe.id_servicio_cafe = costo_produccion.id_servicio_cafe
INNER JOIN tipo_servicio on tipo_servicio.id_tipo_servicio = servicio_cafe.id_tipo_servicio
INNER JOIN unidad_de_medida on unidad_de_medida.id_unidad_medida =costo_produccion.id_unidad_medida
INNER JOIN tipo_materia_prima on tipo_materia_prima.id_tipo_materia = materia_prima.id_tipo_materia
INNER JOIN tipo_empaque on tipo_empaque.id_tipo_empaque = material_empaque.id_tipo_empaque;

END;

$$
LANGUAGE 'plpgsql';

--ejecucion
select * from getallProduccion();

---obtener registro específico
CREATE OR REPLACE FUNCTION getProduccionC(id_C INTEGER)
RETURNS
     TABLE(
		id_costo_produccion INTEGER,
		 fecha DATE,
		 cantidad INTEGER ,
		 precio_venta DOUBLE PRECISION,
		 ganancia_neta DOUBLE PRECISION ,
		 costo_por_libra DOUBLE PRECISION,
		 unidad_de_medida CHARACTER VARYING, 
		 tipo_empaque CHARACTER VARYING,
		 costo_empaque DOUBLE PRECISION,
		 materia_prima CHARACTER VARYING,
		 costo_materia DOUBLE PRECISION,
		 costo_servicio DOUBLE PRECISION,
		 servicio  CHARACTER VARYING
		 
	 )
AS $$
BEGIN
	RETURN QUERY
	SELECT 
	costo_produccion.id_costo_produccion,
costo_produccion.fecha,
costo_produccion.cantidad,
costo_produccion.precio_venta,
costo_produccion.ganancia_neta ,
costo_produccion.costo_por_libra,
unidad_de_medida.nombre,
tipo_empaque.nombre ,
material_empaque.costo_empaque,
tipo_materia_prima.nombre,
materia_prima.costo,
servicio_cafe.costo_servicio,
tipo_servicio.nombre

	FROM costo_produccion
INNER JOIN materia_prima on materia_prima.id_materia_prima = costo_produccion.id_materia_prima
INNER JOIN material_empaque on material_empaque.id_empaque = costo_produccion.id_empaque
 INNER JOIN servicio_cafe on servicio_cafe.id_servicio_cafe = costo_produccion.id_servicio_cafe
INNER JOIN tipo_servicio on tipo_servicio.id_tipo_servicio = servicio_cafe.id_tipo_servicio
INNER JOIN unidad_de_medida on unidad_de_medida.id_unidad_medida =costo_produccion.id_unidad_medida
INNER JOIN tipo_materia_prima on tipo_materia_prima.id_tipo_materia = materia_prima.id_tipo_materia
INNER JOIN tipo_empaque on tipo_empaque.id_tipo_empaque = material_empaque.id_tipo_empaque

WHERE costo_produccion.id_costo_produccion = id_C;

END;
$$
LANGUAGE 'plpgsql';

---ejecuion
SELECT * FROM getProduccionC(3);



---insertar Datos

CREATE OR REPLACE FUNCTION insertProduccionC(
		cantidad INTEGER ,
		 precio_venta INTEGER,
		 costo_por_libra INTEGER,
		 unidad_de_medida INTEGER, 
		 tipo_empaque INTEGER,
	     materia_prima INTEGER,
		 servicio INTEGER
	
	
) RETURNS VOID AS
$$
DECLARE
	fechaActual DATE = (SELECT CURRENT_DATE);
	costo_empaque  DOUBLE PRECISION =( SELECT costo_empaque FROM material_empaque WHERE id_tipo_empaque = $5 );
	costo_servicio DOUBLE PRECISION =(SELECT costo_servicio FROM servicio_cafe WHERE id_servicio_cafe = $7);
    ganancia_neta  DOUBLE PRECISION = 0;
	
BEGIN
	--subtotal=precio_venta * cantidad<-hace falta
	ganancia_neta = precio_venta-(costo + costo_servicio);
	
INSERT INTO costo_produccion(fecha,cantidad,precio_venta,costo_por_libra, ganancia_neta,id_empaque, id_materia_prima, id_unidad_medida, id_servicio_cafe)
VALUES (fechaActual,cantidad,precio_venta,costo_por_libra,ganancia_neta,tipo_empaque,materia_prima,unidad_de_medida,servicio);
END;
$$
LANGUAGE 'plpgsql';

--ejecutar funcion
--inteerPRoducton (cantidad,precioventa,costoLibra,idempaque,idtipomateria,idUnidad,idServicio)
SELECT * FROM insertProduccionC (2,45,25,1,1,2,2);




----FUNCION PARA ACTUALIZAR 
CREATE OR REPLACE FUNCTION updateProduccionC(
	id_C INTEGER,
		cantidad INTEGER ,
		 precio_venta INTEGER,
		 costo_por_libra INTEGER,
		 unidad_de_medida INTEGER, 
		 tipo_empaque INTEGER,
	     materia_prima INTEGER,
		 servicio INTEGER
	
	
) RETURNS VOID AS
$$
DECLARE
	fechaActual DATE = (SELECT CURRENT_DATE);
	costo_empaque  DOUBLE PRECISION =( SELECT costo_empaqu FROM material_empaque WHERE id_tipo_empaque = $6 );
	
	costo_servicio DOUBLE PRECISION =(SELECT costo_servicio FROM servicio_cafe WHERE id_servicio_cafe = $8);
    Calculoganancia_neta  DOUBLE PRECISION = 0;
BEGIN
	--subtotal=precio_venta * cantidad<-hace falta
	Calculoganancia_neta = precio_venta-(costo_empaque + costo_servicio);
	
UPDATE costo_produccion SET fecha =fechaActual ,cantidad =$2, precio_venta=$3, costo_por_libra=$4, ganancia_neta =Calculoganancia_neta,id_empaque =$6, id_materia_prima =$7, id_unidad_medida =$5, id_servicio_cafe=$8
WHERE id_costo_produccion = id_C;
END;   

$$
LANGUAGE 'plpgsql';

--ejecucion de la funcion

SELECT updateProduccionC (3 ,2,45,25,1,1,2,2);

