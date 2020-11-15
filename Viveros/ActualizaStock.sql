
use ADBD_Vivero;
DROP TRIGGER IF EXISTS TRIGGER_ZonaProducto_ActualizaStock_INSERT;
DROP TRIGGER IF EXISTS TRIGGER_ZonaProducto_ActualizaStock_UPDATE;
DROP TRIGGER IF EXISTS TRIGGER_ZonaProducto_ActualizaStock_DELETE;

DELIMITER //
CREATE TRIGGER TRIGGER_ZonaProducto_ActualizaStock_INSERT AFTER INSERT on ADBD_Vivero.Zona_Producto
FOR EACH ROW
BEGIN
	DECLARE cant integer;
    SET cant =  (SELECT sum(Cantidad) from Zona_Producto group by CodigoBarras_Producto having CodigoBarras_Producto = NEW.CodigoBarras_Producto);
    UPDATE Producto set Producto.Stock = cant where Producto.CodigoBarras = NEW.CodigoBarras_Producto;
END//

CREATE TRIGGER TRIGGER_ZonaProducto_ActualizaStock_UPDATE AFTER UPDATE on ADBD_Vivero.Zona_Producto
FOR EACH ROW
BEGIN
	DECLARE cant integer;
    SET cant = (SELECT sum(Cantidad) from Zona_Producto group by CodigoBarras_Producto having CodigoBarras_Producto = NEW.CodigoBarras_Producto);
	UPDATE Producto set Producto.Stock = cant where Producto.CodigoBarras = NEW.CodigoBarras_Producto;
END//

CREATE TRIGGER TRIGGER_ZonaProducto_ActualizaStock_DELETE AFTER DELETE on ADBD_Vivero.Zona_Producto
FOR EACH ROW
BEGIN
	DECLARE cant integer;
	SET cant =  (SELECT sum(Cantidad) from Zona_Producto group by CodigoBarras_Producto having CodigoBarras_Producto = OLD.CodigoBarras_Producto);
	UPDATE Producto set Producto.Stock = cant where Producto.CodigoBarras = OLD.CodigoBarras_Producto;
END//
DELIMITER ;


-- Insertamos las filas necesarias para la prueba
INSERT INTO `ADBD_Vivero`.`Vivero`
(`Ubicacion`,
`Hora Apertura`,
`Hora Cierre`,
`Superficie`)
VALUES
('Santa Cruz de Tenerife',
'09:00',
'20:00',
200);

INSERT INTO `ADBD_Vivero`.`Zona`
(`Codigo`,
`Ubicacion_Vivero`)
VALUES
(12314,
'Santa Cruz de Tenerife');

INSERT INTO `ADBD_Vivero`.`Zona`
(`Codigo`,
`Ubicacion_Vivero`)
VALUES
(4564,
'Santa Cruz de Tenerife');

INSERT INTO `ADBD_Vivero`.`Producto`
(`CodigoBarras`,
`Nombre`,
`Precio`,
`Tipo`)
VALUES
(645561,
'Producto_Test',
10,
'Leche');

-- Insertamos las filas de prueba
INSERT INTO `ADBD_Vivero`.`Zona_Producto`
(`Codigo_Zona`,
`CodigoBarras_Producto`,
`Cantidad`)
VALUES
(4564,
645561,
20);
-- Ahora stock = 20 para el producto con codigo = 645561
select * from Producto;

INSERT INTO `ADBD_Vivero`.`Zona_Producto`
(`Codigo_Zona`,
`CodigoBarras_Producto`,
`Cantidad`)
VALUES
(12314,
645561,
20);
-- Ahora stock = 40 para el producto con codigo = 645561
select * from Producto;


UPDATE Zona_Producto set Cantidad = 10 where Codigo_Zona = 12314;
-- Ahora stock = 30 para el producto con codigo = 645561
select * from Producto;

DELETE from Zona_Producto where Codigo_Zona = 12314;
-- Ahora stock = 20 para el producto con codigo = 645561
select * from Producto;



