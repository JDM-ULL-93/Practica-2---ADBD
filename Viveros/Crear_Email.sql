DELIMITER //
DROP PROCEDURE IF EXISTS crear_email;
CREATE PROCEDURE crear_email( nombre varchar(55), apellidos varchar(55), dominio varchar(55), OUT email varchar(55))
BEGIN
	SET email := CONCAT(nombre,'_',REPLACE(apellidos,' ','_'),'@',dominio);
END//
DELIMITER ;

call crear_email('Javier', 'Duque Melguizo', 'hotmail.com', @output);
select @output;

-- Creamos el trigger en la tabla Cliente que setee
DROP TRIGGER IF EXISTS TRIGGER_Cliente_BI_SetonNULLEmail;
DELIMITER //
CREATE TRIGGER TRIGGER_Cliente_BI_SetonNULLEmail BEFORE INSERT on ADBD_Vivero.Cliente
FOR EACH ROW
BEGIN
	IF NEW.Email is NULL THEN
		call crear_email(NEW.Nombre, NEW.Apellidos, 'dominio.com', @output);
		Set NEW.Email :=  @output;
    END IF;
END//
DELIMITER ;

-- Insertamos dos filas para probar (uno con email == null y otra sin ella)
INSERT INTO `ADBD_Vivero`.`Cliente`
(`DNI`,
`CodSocio`,
`Nombre`,
`Apellidos`,
`Bonificación`,
`GastoMensual`,
`Fecha_Nacimiento`)
VALUES
('54109078Z',
2568,
'Javier',
'Duque Melguizo',
-50,
100,
STR_TO_DATE('25/11/1993','%d/%m/%Y'));

INSERT INTO `ADBD_Vivero`.`Cliente`
(`DNI`,
`CodSocio`,
`Nombre`,
`Apellidos`,
`Email`,
`Bonificación`,
`GastoMensual`,
`Fecha_Nacimiento`)
VALUES
('12345678Z',
5467,
'Prueba',
'Testeo Simulacro',
'teseoSimulacro@hotmail.com',
-50,
100,
STR_TO_DATE('25/11/1993','%d/%m/%Y'));

-- Visualizamos el resultado
use ADBD_Vivero;
select `DNI`,
`CodSocio`,
`Nombre`,
`Apellidos`,
`Email`
`Bonificación`,
`GastoMensual`,
`Fecha_Nacimiento`
from Cliente;