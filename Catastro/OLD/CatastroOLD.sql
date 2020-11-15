-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ADBD_CATASTRO
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ADBD_CATASTRO
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ADBD_CATASTRO` DEFAULT CHARACTER SET utf8 ;
USE `ADBD_CATASTRO` ;

-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Persona`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_CATASTRO`.`Persona` ;

CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Persona` (
  `DNI` VARCHAR(9) NOT NULL,
  `FechaNacimiento` DATETIME NULL,
  `Nombre` VARCHAR(45) NULL,
  `Apellido1` VARCHAR(45) NULL,
  `Apellido2` VARCHAR(45) NULL,
  `Cabeza_Familia` VARCHAR(9) NULL,
  PRIMARY KEY (`DNI`),
  INDEX `FK_CABEZAFAMILIA_PERSONA__PERSONA_idx` (`Cabeza_Familia` ASC),
  CONSTRAINT `FK_CABEZAFAMILIA_PERSONA__PERSONA`
    FOREIGN KEY (`Cabeza_Familia`)
    REFERENCES `ADBD_CATASTRO`.`Persona` (`DNI`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Zona`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_CATASTRO`.`Zona` ;

CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Zona` (
  `Nombre` VARCHAR(55) NOT NULL,
  `Area` DECIMAL NOT NULL,
  `Concejal` VARCHAR(9) NULL,
  CHECK(`Area` > 0),
  PRIMARY KEY (`Nombre`),
  INDEX `FK_CONCEJAL_PERSONA_idx` (`Concejal` ASC),
  CONSTRAINT `FK_CONCEJAL_PERSONA`
    FOREIGN KEY (`Concejal`)
    REFERENCES `ADBD_CATASTRO`.`Persona` (`DNI`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Calle`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_CATASTRO`.`Calle` ;

CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Calle` (
  `Numero` INT NOT NULL,
  `Nombre` VARCHAR(55) NOT NULL,
  `Nombre_Zona` VARCHAR(55) NOT NULL,
  `Longitud` DECIMAL NOT NULL,
  `IdTipo` INT NOT NULL,
  `NumeroCarriles` INT NOT NULL,
  CHECK(`Longitud` > 0),
  PRIMARY KEY (`Numero`),
  INDEX `FK_NOMBRE_ZONA__CALLE_idx` (`Nombre_Zona` ASC),
  CONSTRAINT `FK_NOMBRE_ZONA__CALLE`
    FOREIGN KEY (`Nombre_Zona`)
    REFERENCES `ADBD_CATASTRO`.`Zona` (`Nombre`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Construccion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_CATASTRO`.`Construccion` ;

CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Construccion` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(255) NULL,
  `Numero_Calle` INT NOT NULL,
  `Superficie` DECIMAL NOT NULL,
  `Impuestos` DECIMAL NOT NULL,
  `CoordX` DECIMAL NOT NULL,
  `CoordY` DECIMAL NOT NULL,
  CHECK(`Superficie` > 0),
  PRIMARY KEY (`Id`),
  INDEX `FK_NUMERO_CALLE__CONSTRUCCION_idx` (`Numero_Calle` ASC),
  CONSTRAINT `FK_NUMERO_CALLE__CONSTRUCCION`
    FOREIGN KEY (`Numero_Calle`)
    REFERENCES `ADBD_CATASTRO`.`Calle` (`Numero`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Bloque`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_CATASTRO`.`Bloque` ;

CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Bloque` (
  `Letra` VARCHAR(3) NOT NULL DEFAULT 'A',
  `Id_Construccion` INT NOT NULL,
  `Superficie` DECIMAL NOT NULL,
  CHECK(`Superficie` > 0),
  PRIMARY KEY (`Letra`, `Id_Construccion`),
  INDEX `FK_ID_CONSTRUCCION__BLOQUE_idx` (`Id_Construccion` ASC),
  CONSTRAINT `FK_ID_CONSTRUCCION__BLOQUE`
    FOREIGN KEY (`Id_Construccion`)
    REFERENCES `ADBD_CATASTRO`.`Construccion` (`Id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Piso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_CATASTRO`.`Piso` ;

CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Piso` (
  `Numero` INT NOT NULL,
  `Letra_Bloque` VARCHAR(3) NOT NULL,
  `Id_Construccion` INT NOT NULL,
  `Superficie` DECIMAL NULL,
  CHECK(`Superficie` > 0),
  PRIMARY KEY (`Numero`, `Letra_Bloque`, `Id_Construccion`),
  INDEX `FK_LETRA_BLOQUE__PISO_idx` (`Letra_Bloque` ASC),
  INDEX `FK_ID_CONSTRUCCION__PISO_idx` (`Id_Construccion` ASC),
  CONSTRAINT `FK_LETRA_BLOQUE__PISO`
    FOREIGN KEY (`Letra_Bloque`)
    REFERENCES `ADBD_CATASTRO`.`Bloque` (`Letra`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `FK_ID_CONSTRUCCION__PISO`
    FOREIGN KEY (`Id_Construccion`)
    REFERENCES `ADBD_CATASTRO`.`Construccion` (`Id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ADBD_CATASTRO`.`Vivienda`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ADBD_CATASTRO`.`Vivienda` ;

CREATE TABLE IF NOT EXISTS `ADBD_CATASTRO`.`Vivienda` (
  `Puerta` VARCHAR(3) NOT NULL DEFAULT 'A',
  `Numero_Piso` INT NULL DEFAULT 0,
  `Letra_Bloque` VARCHAR(3) NULL DEFAULT '0',
  `Id_Construccion` INT NOT NULL,
  `Superficie` DECIMAL NOT NULL,
  CHECK(`Superficie` > 0),
  PRIMARY KEY (`Puerta`, `Id_Construccion`),
  INDEX `FK_NUMERO_PISO__VIVIENDA_idx` (`Numero_Piso` ASC),
  INDEX `FK_LETRA_BLOQUE__VIVIENDA_idx` (`Letra_Bloque` ASC),
  INDEX `FK_ID_CONSTRUCCION__VIVIENDA_idx` (`Id_Construccion` ASC),
  UNIQUE INDEX `Numero_Piso_UNIQUE` (`Numero_Piso` ASC),
  UNIQUE INDEX `Letra_Bloque_UNIQUE` (`Letra_Bloque` ASC),
  CONSTRAINT `FK_NUMERO_PISO__VIVIENDA`
    FOREIGN KEY (`Numero_Piso`)
    REFERENCES `ADBD_CATASTRO`.`Piso` (`Numero`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `FK_LETRA_BLOQUE__VIVIENDA`
    FOREIGN KEY (`Letra_Bloque`)
    REFERENCES `ADBD_CATASTRO`.`Bloque` (`Letra`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `FK_ID_CONSTRUCCION__VIVIENDA`
    FOREIGN KEY (`Id_Construccion`)
    REFERENCES `ADBD_CATASTRO`.`Construccion` (`Id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
