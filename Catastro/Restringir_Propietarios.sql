use ADBD_CATASTRO;

DROP TRIGGER IF EXISTS TRIGGER_Vivienda_BI_CheckNo2Personas;

DELIMITER //
CREATE TRIGGER TRIGGER_Vivienda_BI_CheckNo2Personas BEFORE INSERT on ADBD_CATASTRO.Vivienda
FOR EACH ROW
BEGIN
	DECLARE cantidad integer;
    SET cantidad =  (SELECT count(Vivienda.Propietario) from Vivienda group by Vivienda.Propietario having Vivienda.Propietario = NEW.Propietario);
    IF cantidad != 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un propietario con otra vivienda';
    END IF;
END//
DELIMITER ;

-- Creamos las filas necesarias para la prueba
INSERT INTO `ADBD_CATASTRO`.`Persona`
(`DNI`,
`FechaNacimiento`,
`Nombre`,
`Apellido1`,
`Apellido2`)
VALUES
('54109078Z',
STR_TO_DATE('25/11/1993','%d/%m/%Y'),
'Javier',
'Duque',
'Melguizo'
);

INSERT INTO `ADBD_CATASTRO`.`Zona`
(`Nombre`,
`Area`,
`Concejal`)
VALUES
('Los Majuelos',
100,
'54109078Z');

INSERT INTO `ADBD_CATASTRO`.`Calle`
(`Numero`,
`Nombre`,
`Nombre_Zona`,
`Longitud`,
`IdTipo`,
`NumeroCarriles`)
VALUES
(1,
'Volcan Estromboli',
'Los Majuelos',
100,
0,
1);


INSERT INTO `ADBD_CATASTRO`.`Construccion`
(`Descripcion`,
`Numero_Calle`,
`Superficie`,
`Impuestos`,
`CoordX`,
`CoordY`)
VALUES
('Este edificio es solo de prueba',
1,
100,
0,
1,
1);



-- La prueba. Esta primera deberia dejar insertar correctamente
INSERT INTO `ADBD_CATASTRO`.`Vivienda`
(`Puerta`,
`Id_Construccion`,
`Superficie`,
`Propietario`)
VALUES
('A',
2,
100,
'54109078Z');

-- Esta no. Deberia salir "Error Code: 1644. Ya existe un propietario con otra vivienda"
INSERT INTO `ADBD_CATASTRO`.`Vivienda`
(`Puerta`,
`Id_Construccion`,
`Superficie`,
`Propietario`)
VALUES
('A',
2,
100,
'54109078Z');

select * from `ADBD_CATASTRO`.`Vivienda`;