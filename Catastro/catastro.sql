-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ADBD_CATASTRO
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ADBD_CATASTRO
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ADBD_CATASTRO` DEFAULT CHARACTER SET latin1 ;
USE `ADBD_CATASTRO` ;

-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Persona` (
  `DNI` VARCHAR(9) NOT NULL,
  `FechaNacimiento` DATETIME NULL DEFAULT NULL,
  `Nombre` VARCHAR(45) NULL DEFAULT NULL,
  `Apellido1` VARCHAR(45) NULL DEFAULT NULL,
  `Apellido2` VARCHAR(45) NULL DEFAULT NULL,
  `Cabeza_Familia` VARCHAR(9) NULL DEFAULT NULL,
  PRIMARY KEY (`DNI`),
  INDEX `FK_CABEZAFAMILIA_PERSONA__PERSONA_idx` (`Cabeza_Familia` ASC),
  CONSTRAINT `FK_CABEZAFAMILIA_PERSONA__PERSONA`
    FOREIGN KEY (`Cabeza_Familia`)
    REFERENCES `ADBD_CATASTRO`.`Persona` (`DNI`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Zona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Zona` (
  `Nombre` VARCHAR(55) NOT NULL,
  `Area` DECIMAL(10,0) NOT NULL,
  `Concejal` VARCHAR(9) NULL DEFAULT NULL,
  PRIMARY KEY (`Nombre`),
  INDEX `FK_CONCEJAL_PERSONA_idx` (`Concejal` ASC),
  CONSTRAINT `FK_CONCEJAL_PERSONA`
    FOREIGN KEY (`Concejal`)
    REFERENCES `ADBD_CATASTRO`.`Persona` (`DNI`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Calle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Calle` (
  `Numero` INT(11) NOT NULL,
  `Nombre` VARCHAR(55) NOT NULL,
  `Nombre_Zona` VARCHAR(55) NOT NULL,
  `Longitud` DECIMAL(10,0) NOT NULL,
  `IdTipo` INT(11) NOT NULL,
  `NumeroCarriles` INT(11) NOT NULL,
  PRIMARY KEY (`Numero`),
  INDEX `FK_NOMBRE_ZONA__CALLE_idx` (`Nombre_Zona` ASC),
  CONSTRAINT `FK_NOMBRE_ZONA__CALLE`
    FOREIGN KEY (`Nombre_Zona`)
    REFERENCES `ADBD_CATASTRO`.`Zona` (`Nombre`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Construccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Construccion` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(255) NULL DEFAULT NULL,
  `Numero_Calle` INT(11) NOT NULL,
  `Superficie` DECIMAL(10,0) NOT NULL,
  `Impuestos` DECIMAL(10,0) NOT NULL,
  `CoordX` DECIMAL(10,0) NOT NULL,
  `CoordY` DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (`Id`),
  INDEX `FK_NUMERO_CALLE__CONSTRUCCION_idx` (`Numero_Calle` ASC),
  CONSTRAINT `FK_NUMERO_CALLE__CONSTRUCCION`
    FOREIGN KEY (`Numero_Calle`)
    REFERENCES `ADBD_CATASTRO`.`Calle` (`Numero`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Bloque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Bloque` (
  `Letra` VARCHAR(3) NOT NULL DEFAULT 'A',
  `Id_Construccion` INT(11) NOT NULL,
  `Superficie` DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (`Letra`, `Id_Construccion`),
  INDEX `FK_ID_CONSTRUCCION__BLOQUE_idx` (`Id_Construccion` ASC),
  CONSTRAINT `FK_ID_CONSTRUCCION__BLOQUE`
    FOREIGN KEY (`Id_Construccion`)
    REFERENCES `ADBD_CATASTRO`.`Construccion` (`Id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Piso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Piso` (
  `Numero` INT(11) NOT NULL,
  `Letra_Bloque` VARCHAR(3) NOT NULL,
  `Id_Construccion` INT(11) NOT NULL,
  `Superficie` DECIMAL(10,0) NULL DEFAULT NULL,
  PRIMARY KEY (`Numero`, `Letra_Bloque`, `Id_Construccion`),
  INDEX `FK_LETRA_BLOQUE__PISO_idx` (`Letra_Bloque` ASC),
  INDEX `FK_ID_CONSTRUCCION__PISO_idx` (`Id_Construccion` ASC),
  CONSTRAINT `FK_ID_CONSTRUCCION__PISO`
    FOREIGN KEY (`Id_Construccion`)
    REFERENCES `ADBD_CATASTRO`.`Construccion` (`Id`)
    ON UPDATE CASCADE,
  CONSTRAINT `FK_LETRA_BLOQUE__PISO`
    FOREIGN KEY (`Letra_Bloque`)
    REFERENCES `ADBD_CATASTRO`.`Bloque` (`Letra`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Vivienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Vivienda` (
  `Puerta` VARCHAR(3) NOT NULL DEFAULT 'A',
  `Numero_Piso` INT(11) NULL DEFAULT NULL,
  `Letra_Bloque` VARCHAR(3) NULL DEFAULT NULL,
  `Id_Construccion` INT(11) NOT NULL,
  `Superficie` DECIMAL(10,0) NOT NULL,
  `Propietario` VARCHAR(9) NULL DEFAULT NULL,
  PRIMARY KEY (`Puerta`, `Id_Construccion`),
  UNIQUE INDEX `Numero_Piso_UNIQUE` (`Numero_Piso` ASC),
  UNIQUE INDEX `Letra_Bloque_UNIQUE` (`Letra_Bloque` ASC),
  INDEX `FK_NUMERO_PISO__VIVIENDA_idx` (`Numero_Piso` ASC),
  INDEX `FK_LETRA_BLOQUE__VIVIENDA_idx` (`Letra_Bloque` ASC),
  INDEX `FK_ID_CONSTRUCCION__VIVIENDA_idx` (`Id_Construccion` ASC),
  INDEX `FK_PROPIETARIO_PERSONA__VIVIENDA_idx` (`Propietario` ASC),
  CONSTRAINT `FK_ID_CONSTRUCCION__VIVIENDA`
    FOREIGN KEY (`Id_Construccion`)
    REFERENCES `ADBD_CATASTRO`.`Construccion` (`Id`)
    ON UPDATE CASCADE,
  CONSTRAINT `FK_LETRA_BLOQUE__VIVIENDA`
    FOREIGN KEY (`Letra_Bloque`)
    REFERENCES `ADBD_CATASTRO`.`Bloque` (`Letra`)
    ON DELETE SET NULL
    ON UPDATE SET NULL,
  CONSTRAINT `FK_NUMERO_PISO__VIVIENDA`
    FOREIGN KEY (`Numero_Piso`)
    REFERENCES `ADBD_CATASTRO`.`Piso` (`Numero`)
    ON DELETE SET NULL
    ON UPDATE SET NULL,
  CONSTRAINT `FK_PROPIETARIO_PERSONA__VIVIENDA`
    FOREIGN KEY (`Propietario`)
    REFERENCES `ADBD_CATASTRO`.`Persona` (`DNI`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `ADBD_CATASTRO`;

DELIMITER $$
USE `ADBD_CATASTRO`$$
CREATE
DEFINER=`external`@`%`
TRIGGER `ADBD_CATASTRO`.`TRIGGER_Vivienda_BI_CheckNo2Personas`
BEFORE INSERT ON `ADBD_CATASTRO`.`Vivienda`
FOR EACH ROW
BEGIN
	DECLARE cantidad integer;
    SET cantidad =  (SELECT count(Vivienda.Propietario) from Vivienda group by Vivienda.Propietario having Vivienda.Propietario = NEW.Propietario);
    IF cantidad != 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un propietario con otra vivienda';
    END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
