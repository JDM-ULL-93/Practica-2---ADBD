CREATE TABLE ADBD_CATASTRO.ZONA(
	nombre varchar(255) NOT NULL, 
	area double,
	concejal int,
	PRIMARY KEY(nombre),
	FOREIGN KEY(concejal)
		REFERENCES PERSONA(DNI) ON DELETE RESTRICT 
);

CREATE TABLE ADBD_CATASTRO.CALLE( 
	numero int NOT NULL,
	nombre varchar(255) NOT NULL, 
	longitud int, 
	tipo varchar(255), 
	cant_carriles int,
	zona varchar(255) NOT NULL,
	CHECK (cant_carriles>0),
	PRIMARY KEY(numero,nombre),
	FOREIGN KEY(zona)
		REFERENCES ZONA(nombre) ON DELETE RESTRICT 
);  

CREATE TABLE ADBD_CATASTRO.CONSTRUCCION(
	id int NOT NULL AUTO_INCREMENT,
    descripcion varchar(255),
    calle varchar(255) NOT NULL,
    superficie double,
    impuestos double NOT NULL,
    coordsX double NOT NULL,
    coordsY double NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(calle)
		REFERENCES CALLE(nombre) ON DELETE RESTRICT
);

CREATE TABLE ADBD_CATASTRO.BLOQUE(
	letra char NOT NULL DEFAULT 'A',
	id_construccion int NOT NULL,
    superficie double,
    CHECK (superficie > 0),
    PRIMARY KEY(letra,id_construccion),
    FOREIGN KEY(id_construccion)
		REFERENCES CONSTRUCCION(id) ON DELETE RESTRICT
);

CREATE TABLE ADBD_CATASTRO.PISO(
	id_construccion int NOT NULL,
    letra_bloque char NOT NULL,
    superficie double,
    piso int NOT NULL,
    CHECK (superficie > 0),
    PRIMARY KEY(piso,letra_bloque,id_construccion),
    FOREIGN KEY(id_construccion)
		REFERENCES BLOQUE(id_construccion) ON DELETE RESTRICT,
	FOREIGN KEY(letra_bloque)
		REFERENCES BLOQUE(letra) ON DELETE RESTRICT
);

CREATE TABLE ADBD_CATASTRO.VIVIENDA(
	puerta char NOT NULL DEFAULT 'A',
	superficie double,
    piso int , #Pero entonces obligo a que una vivienda unifamiliar deberá tener un piso con numero = 0
    letra_bloque char NOT NULL,
    id_construccion int NOT NULL,
    CHECK (superficie > 0),
    PRIMARY KEY(puerta, piso, letra_bloque, id_construccion),
    FOREIGN KEY(piso)
		REFERENCES PISO(piso) ON DELETE RESTRICT,
	FOREIGN KEY(letra_bloque)
		REFERENCES BLOQUE(letra) ON DELETE RESTRICT,
	FOREIGN KEY(id_construccion)
		REFERENCES BLOQUE(id_construccion) ON DELETE RESTRICT
);