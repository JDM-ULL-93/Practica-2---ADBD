-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ADBD_Vivero
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ADBD_Vivero
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ADBD_Vivero` DEFAULT CHARACTER SET latin1 ;
USE `ADBD_Vivero` ;

-- -----------------------------------------------------
-- Table `ADBD_Vivero`.`Cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_Vivero`.`Cliente` ;

CREATE TABLE IF NOT EXISTS `ADBD_Vivero`.`Cliente` (
  `DNI` VARCHAR(9) NOT NULL,
  `CodSocio` INT(11) NOT NULL,
  `Nombre` VARCHAR(45) NOT NULL,
  `Apellidos` VARCHAR(255) NULL DEFAULT NULL,
  `Email` VARCHAR(255) NULL DEFAULT NULL,
  `Bonificación` INT(11) NOT NULL,
  `GastoMensual` INT(10) UNSIGNED ZEROFILL NULL DEFAULT NULL,
  `Fecha_Nacimiento` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`DNI`, `CodSocio`),
  UNIQUE INDEX `DNI_UNIQUE` (`DNI` ASC),
  UNIQUE INDEX `IdSocio_UNIQUE` (`CodSocio` ASC),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_Vivero`.`Empleado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_Vivero`.`Empleado` ;

CREATE TABLE IF NOT EXISTS `ADBD_Vivero`.`Empleado` (
  `DNI` VARCHAR(9) NOT NULL,
  `CódigoSeguridadSocial` VARCHAR(45) NOT NULL,
  `Nombre` VARCHAR(45) NULL DEFAULT NULL,
  `Sueldo` DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (`DNI`),
  UNIQUE INDEX `DNI_UNIQUE` (`DNI` ASC),
  UNIQUE INDEX `CódigoSeguridadSocial_UNIQUE` (`CódigoSeguridadSocial` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_Vivero`.`Pedido_Gestion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_Vivero`.`Pedido_Gestion` ;

CREATE TABLE IF NOT EXISTS `ADBD_Vivero`.`Pedido_Gestion` (
  `ID` INT(11) NOT NULL,
  `DNI_Cliente` VARCHAR(9) NOT NULL,
  `DNI_Empleado` VARCHAR(9) NOT NULL,
  `Fecha` DATE NOT NULL,
  `Importe` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`ID`, `DNI_Cliente`, `DNI_Empleado`),
  INDEX `DNI_idx` (`DNI_Cliente` ASC),
  INDEX `DNI Empleado Gestor_idx` (`DNI_Empleado` ASC),
  CONSTRAINT `FK_DNI_Cliente__Pedido_Gestion`
    FOREIGN KEY (`DNI_Cliente`)
    REFERENCES `ADBD_Vivero`.`Cliente` (`DNI`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_DNI_Empleado__Pedido_Gestion`
    FOREIGN KEY (`DNI_Empleado`)
    REFERENCES `ADBD_Vivero`.`Empleado` (`DNI`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_Vivero`.`Producto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_Vivero`.`Producto` ;

CREATE TABLE IF NOT EXISTS `ADBD_Vivero`.`Producto` (
  `CodigoBarras` INT(11) NOT NULL,
  `Nombre` VARCHAR(45) NOT NULL,
  `Precio` INT(11) NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `Stock` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`CodigoBarras`),
  UNIQUE INDEX `CódigoBarras_UNIQUE` (`CodigoBarras` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_Vivero`.`Pedido_Registro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_Vivero`.`Pedido_Registro` ;

CREATE TABLE IF NOT EXISTS `ADBD_Vivero`.`Pedido_Registro` (
  `CódigoBarras` INT(11) NOT NULL,
  `Id` INT(11) NOT NULL,
  `Cantidad` INT(11) NOT NULL,
  PRIMARY KEY (`CódigoBarras`, `Id`),
  INDEX `FK_Id_Cliente_Pedido_idx` (`Id` ASC),
  CONSTRAINT `FK_CodigoBarras_Producto__Pedido_Registro`
    FOREIGN KEY (`CódigoBarras`)
    REFERENCES `ADBD_Vivero`.`Producto` (`CodigoBarras`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Id_Pedido_Gestion__Pedido_Registro`
    FOREIGN KEY (`Id`)
    REFERENCES `ADBD_Vivero`.`Pedido_Gestion` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_Vivero`.`Vivero`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_Vivero`.`Vivero` ;

CREATE TABLE IF NOT EXISTS `ADBD_Vivero`.`Vivero` (
  `Ubicacion` VARCHAR(80) NOT NULL,
  `Hora Apertura` TIME NOT NULL,
  `Hora Cierre` TIME NOT NULL,
  `Superficie` DOUBLE NULL DEFAULT NULL,
  PRIMARY KEY (`Ubicacion`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_Vivero`.`Zona`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_Vivero`.`Zona` ;

CREATE TABLE IF NOT EXISTS `ADBD_Vivero`.`Zona` (
  `Codigo` INT(11) NOT NULL,
  `Ubicacion_Vivero` VARCHAR(80) NOT NULL,
  `Nombre` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Codigo`, `Ubicacion_Vivero`),
  INDEX `UbicacionVivero_idx` (`Ubicacion_Vivero` ASC),
  CONSTRAINT `FK_Ubicacion_Vivero__Zona`
    FOREIGN KEY (`Ubicacion_Vivero`)
    REFERENCES `ADBD_Vivero`.`Vivero` (`Ubicacion`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_Vivero`.`Zona_Empleado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_Vivero`.`Zona_Empleado` ;

CREATE TABLE IF NOT EXISTS `ADBD_Vivero`.`Zona_Empleado` (
  `DNI_Empleado` VARCHAR(9) NOT NULL,
  `Codigo_Zona` INT(11) NOT NULL,
  `Fecha_Ini` DATETIME NOT NULL,
  `Fecha_Fin` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`DNI_Empleado`, `Codigo_Zona`),
  INDEX `DNI_idx` (`DNI_Empleado` ASC),
  INDEX `Codigo_idx` (`Codigo_Zona` ASC),
  CONSTRAINT `FK_Codigo_Zona__Zona_Empleado`
    FOREIGN KEY (`Codigo_Zona`)
    REFERENCES `ADBD_Vivero`.`Zona` (`Codigo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_DNI_Empleado__Zona_Empleado`
    FOREIGN KEY (`DNI_Empleado`)
    REFERENCES `ADBD_Vivero`.`Empleado` (`DNI`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_Vivero`.`Zona_Producto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_Vivero`.`Zona_Producto` ;

CREATE TABLE IF NOT EXISTS `ADBD_Vivero`.`Zona_Producto` (
  `Codigo_Zona` INT(11) NOT NULL,
  `CodigoBarras_Producto` INT(11) NOT NULL,
  `Cantidad` INT(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Codigo_Zona`, `CodigoBarras_Producto`),
  INDEX `Producto_idx` (`CodigoBarras_Producto` ASC),
  CONSTRAINT `FK_CodigoBarras_Producto__Zona_Producto`
    FOREIGN KEY (`CodigoBarras_Producto`)
    REFERENCES `ADBD_Vivero`.`Producto` (`CodigoBarras`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Codigo_Zona__Zona_Producto`
    FOREIGN KEY (`Codigo_Zona`)
    REFERENCES `ADBD_Vivero`.`Zona` (`Codigo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `ADBD_Vivero` ;

-- -----------------------------------------------------
-- procedure crear_email
-- -----------------------------------------------------

USE `ADBD_Vivero`;
DROP procedure IF EXISTS `ADBD_Vivero`.`crear_email`;

DELIMITER $$
USE `ADBD_Vivero`$$
CREATE DEFINER=`external`@`%` PROCEDURE `crear_email`( nombre varchar(55), apellidos varchar(55), dominio varchar(55), OUT email varchar(55))
BEGIN
	SET email := CONCAT(nombre,'_',REPLACE(apellidos,' ','_'),'@',dominio);
END$$

DELIMITER ;
USE `ADBD_Vivero`;

DELIMITER $$

USE `ADBD_Vivero`$$
DROP TRIGGER IF EXISTS `ADBD_Vivero`.`TRIGGER_Cliente_BI_SetonNULLEmail` $$
USE `ADBD_Vivero`$$
CREATE
DEFINER=`external`@`%`
TRIGGER `ADBD_Vivero`.`TRIGGER_Cliente_BI_SetonNULLEmail`
BEFORE INSERT ON `ADBD_Vivero`.`Cliente`
FOR EACH ROW
BEGIN
	IF NEW.Email is NULL THEN
		call crear_email(NEW.Nombre, NEW.Apellidos, 'dominio.com', @output);
		Set NEW.Email :=  @output;
    END IF;
END$$


USE `ADBD_Vivero`$$
DROP TRIGGER IF EXISTS `ADBD_Vivero`.`TRIGGER_ZonaProducto_ActualizaStock_INSERT` $$
USE `ADBD_Vivero`$$
CREATE
DEFINER=`external`@`%`
TRIGGER `ADBD_Vivero`.`TRIGGER_ZonaProducto_ActualizaStock_INSERT`
AFTER INSERT ON `ADBD_Vivero`.`Zona_Producto`
FOR EACH ROW
BEGIN
	DECLARE cant integer;
    SET cant =  (SELECT sum(Cantidad) from Zona_Producto group by CodigoBarras_Producto having CodigoBarras_Producto = NEW.CodigoBarras_Producto);
    UPDATE Producto set Producto.Stock = cant where Producto.CodigoBarras = NEW.CodigoBarras_Producto;
END$$


USE `ADBD_Vivero`$$
DROP TRIGGER IF EXISTS `ADBD_Vivero`.`TRIGGER_ZonaProducto_ActualizaStock_UPDATE` $$
USE `ADBD_Vivero`$$
CREATE
DEFINER=`external`@`%`
TRIGGER `ADBD_Vivero`.`TRIGGER_ZonaProducto_ActualizaStock_UPDATE`
AFTER UPDATE ON `ADBD_Vivero`.`Zona_Producto`
FOR EACH ROW
BEGIN
	DECLARE cant integer;
    SET cant = (SELECT sum(Cantidad) from Zona_Producto group by CodigoBarras_Producto having CodigoBarras_Producto = NEW.CodigoBarras_Producto);
	UPDATE Producto set Producto.Stock = cant where Producto.CodigoBarras = NEW.CodigoBarras_Producto;
END$$


USE `ADBD_Vivero`$$
DROP TRIGGER IF EXISTS `ADBD_Vivero`.`TRIGGER_ZonaProducto_ActualizaStock_DELETE` $$
USE `ADBD_Vivero`$$
CREATE
DEFINER=`external`@`%`
TRIGGER `ADBD_Vivero`.`TRIGGER_ZonaProducto_ActualizaStock_DELETE`
AFTER DELETE ON `ADBD_Vivero`.`Zona_Producto`
FOR EACH ROW
BEGIN
	DECLARE cant integer;
	SET cant =  (SELECT sum(Cantidad) from Zona_Producto group by CodigoBarras_Producto having CodigoBarras_Producto = OLD.CodigoBarras_Producto);
	UPDATE Producto set Producto.Stock = cant where Producto.CodigoBarras = OLD.CodigoBarras_Producto;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
