-- phpMyAdmin SQL Dump
-- version 4.6.3deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 05, 2016 at 11:20 AM
-- Server version: 5.6.30-1
-- PHP Version: 7.0.7-5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `taller`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`sandbox`@`localhost` PROCEDURE `AgregoMecanico` (IN `_nombre` VARCHAR(30), IN `_apellido` VARCHAR(35), IN `_direccion` VARCHAR(50), IN `_telefono` VARCHAR(15))  BEGIN
    -- Variables
    DECLARE _id SMALLINT(5) UNSIGNED DEFAULT 0;
    DECLARE _categoria SMALLINT(5) UNSIGNED DEFAULT NULL;

    -- Obtengo id del nuevo mecánico
    SELECT MAX(MECANICO)
    INTO _id
    FROM mecanicos;

    SET _id = _id +1;

    -- Obtengo id de la categoría ayudante de mecánico
    SELECT CATEGORIA INTO _categoria FROM categorias WHERE DESCRIPCION = 'AYUDANTE DE MECANICO';

    -- Inserto el nuevo ayudante de mecánico
    INSERT INTO mecanicos (MECANICO, NOMBRE, APELLIDO, CATEGORIA, DIRECCION, TELEFONO)
    VALUES (_id, _nombre, _apellido, _categoria, _direccion, _telefono);
  END$$

CREATE DEFINER=`sandbox`@`localhost` PROCEDURE `Aumento` (IN `_importe` DECIMAL(8,2), IN `_porcentaje` DECIMAL(5,2))  BEGIN
    UPDATE categorias
    SET SUELDO = SUELDO * (1 + (_porcentaje/100))
    WHERE SUELDO < _importe;
  END$$

CREATE DEFINER=`sandbox`@`localhost` PROCEDURE `EliminoUltimoMecanico` ()  BEGIN
    -- Variables
    DECLARE _id SMALLINT(5) UNSIGNED DEFAULT NULL;

    -- Obtengo id del último mecánico
    SELECT max(MECANICO)
    INTO _id
    FROM mecanicos;

    -- Borro el último mecánico
    DELETE FROM mecanicos
    WHERE MECANICO = _id;
  END$$

CREATE DEFINER=`sandbox`@`localhost` PROCEDURE `FinTrabajo` (IN `_nroTrabajo` SMALLINT(5) UNSIGNED, IN `_precio` DECIMAL(10,2), IN `_salida` DATE)  BEGIN
    -- Variables
    DECLARE _matricula VARCHAR(10) DEFAULT NULL;

    -- Obtengo matricula del trabajo
    SELECT MATRICULA
    INTO _matricula
    FROM trabajos
    WHERE NROTRABAJO = _nroTrabajo;

    IF CantidadDias(_matricula) = 0 AND _matricula IS NOT NULL
    THEN
      UPDATE trabajos
      SET PRECIO = _precio, SALIDA = _salida
      WHERE NROTRABAJO = _nroTrabajo;
    END IF;
  END$$

CREATE DEFINER=`sandbox`@`localhost` PROCEDURE `MarcaModelo` (IN `_marca` VARCHAR(255), IN `_modelo` VARCHAR(255))  BEGIN
    -- Variables
    DECLARE msg TEXT DEFAULT '';
    DECLARE cantidadBuscados INT DEFAULT 0;
    DECLARE cantidadTotal INT DEFAULT 0;
    DECLARE porcentaje INT DEFAULT 0;

    -- Cantidad de autos de esa marca y modelo
    SELECT COUNT(*)
    INTO cantidadBuscados
    FROM autos
    WHERE MARCA = _marca AND MODELO = _modelo;

    -- Cantidad de autos total
    SELECT COUNT(*)
    INTO cantidadTotal
    FROM autos;

    -- Porcentaje
    SET porcentaje = (cantidadBuscados / cantidadTotal) * 100;

    -- Construyo mensaje
    SET msg = CONCAT('Cantidad de autos de la marca ', _marca, ' modelo ', _modelo, ' es ', cantidadBuscados,
                      ' unidades, la cantidad total de autos en el taller ', cantidadTotal, ', siendo el porcentaje de ',
                      porcentaje, '%.');

    -- Selección final
    SELECT
      autos.*,
      msg AS Mensaje
    FROM autos
    WHERE MARCA = _marca AND MODELO = _modelo;
  END$$

CREATE DEFINER=`sandbox`@`localhost` PROCEDURE `Taxi` ()  BEGIN
    UPDATE autos
    SET COLOR = 'Blanco'
    WHERE MARCA IN ('Opel', 'Fiat');
  END$$

CREATE DEFINER=`sandbox`@`localhost` PROCEDURE `TerminoSiNo` (IN `_matricula` VARCHAR(10))  BEGIN
    -- Variables
    DECLARE _existe INT DEFAULT 0;

    -- Existe el auto?
    SELECT COUNT(*)
    INTO _existe
    FROM autos
    WHERE MATRICULA = _matricula;

    -- Muestro mensaje correspondiente
    IF _existe = 0
    THEN
      SELECT 'NO EXISTE AUTO EN EL TALLER' AS Mensaje;
    ELSE
      IF CantidadDias(_matricula) = 0
      THEN
        SELECT 'NO TERMINADO' AS Mensaje;
      ELSE
        SELECT 'TERMINADO' AS Mensaje;
      END IF;
    END IF;
  END$$

--
-- Functions
--
CREATE DEFINER=`sandbox`@`localhost` FUNCTION `CantidadDias` (`_matricula` VARCHAR(10)) RETURNS INT(11) BEGIN
    -- Variables
    DECLARE _entrada DATE DEFAULT NULL;
    DECLARE _salida DATE DEFAULT NULL;

    -- Obtengo fechas
    SELECT ENTRADA, SALIDA
    INTO _entrada, _salida
    FROM trabajos
    WHERE MATRICULA = _matricula;

    -- Retorno cantidad de días
    RETURN ifnull(datediff(_salida, _entrada), 0);
  END$$

CREATE DEFINER=`sandbox`@`localhost` FUNCTION `IVA` (`_matricula` VARCHAR(10)) RETURNS DECIMAL(10,2) BEGIN
    -- Variables
    DECLARE _iva DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE _total DECIMAL(10, 2) DEFAULT 0.00;

    -- Obtengo Precio
    SELECT PRECIO
    INTO _total
    FROM trabajos
    WHERE MATRICULA = _matricula;

    -- Calculo iva
    SET _iva = _total - (_total / 1.22);

    -- Lo retorno
    RETURN _iva;
  END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `autos`
--

CREATE TABLE `autos` (
  `MATRICULA` varchar(10) NOT NULL,
  `MARCA` varchar(20) DEFAULT NULL,
  `MODELO` varchar(30) DEFAULT NULL,
  `AÑO` varchar(4) DEFAULT NULL,
  `COLOR` varchar(20) DEFAULT NULL,
  `SEGURO` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `autos`
--

INSERT INTO `autos` (`MATRICULA`, `MARCA`, `MODELO`, `AÑO`, `COLOR`, `SEGURO`) VALUES
('A-125885', 'BMW', '320i', '1988', 'Blanco', -1),
('B-101128', 'Fiat', 'Uno', '1991', 'Blanco', -1),
('B-101401', 'Fiat', 'Tipo', '1991', 'Blanco', -1),
('B-101781', 'Fiat', 'Premio', '1992', 'Blanco', -1),
('B-101870', 'Opel', 'Record', '1991', 'Blanco', -1),
('B-102102', 'VW', 'Gol', '1986', 'Rojo', 0),
('B-102108', 'Ford', 'Escort XRi', '1991', 'Blanco', -1),
('B-102109', 'Ford', 'Escort XRi', '1991', 'Negro', 0),
('B-103157', 'BMW', '320i', '1992', 'Negro', -1),
('B-103158', 'Opel', 'Record', '1989', 'Blanco', -1),
('B-103159', 'VW', 'Parati', '1988', 'Blanco', 0),
('B-10358', 'VW', 'Gol', '1990', 'Rojo', -1),
('B-104104', 'VW', 'Passat', '1987', 'Amarillo', -1),
('B-104580', 'Fiat', 'Uno', '1991', 'Blanco', 0),
('B-104741', 'Ford', 'Corcel', '1986', 'Azul', -1),
('B-104795', 'VW', 'Gol', '1987', 'Azul', -1),
('B-105105', 'VW', 'Gol', '1986', 'Blanco', -1),
('B-106795', 'Fiat', 'Uno', '1988', 'Blanco', -1),
('B-106968', 'Fiat', 'Uno', '1991', 'Blanco', -1),
('B-107954', 'Fiat', 'Duna', '1989', 'Blanco', -1),
('B-108789', 'Fiat', 'Uno', '1991', 'Blanco', -1),
('B-111258', 'Ford', 'Escort', '1992', 'Blanco', -1),
('B-115850', 'Fiat', 'Uno', '1986', 'Blanco', 0),
('B-123548', 'Fiat', 'Uno', '1989', 'Blanco', -1),
('B-128680', 'Ford', 'Escort', '1988', 'Azul', -1),
('B-130444', 'VW', 'Parati', '1987', 'Blanco', 0),
('B-130458', 'BMW', '320i', '1990', 'Rojo', 0),
('B-14358', 'Ford', 'Escort', '1986', 'Rojo', -1),
('B-99870', 'Fiat', 'Uno', '1991', 'Blanco', -1),
('C-8855', 'Opel', 'Ascona', '1990', 'Blanco', 0);

-- --------------------------------------------------------

--
-- Table structure for table `categorias`
--

CREATE TABLE `categorias` (
  `CATEGORIA` smallint(5) UNSIGNED NOT NULL,
  `DESCRIPCION` varchar(30) DEFAULT NULL,
  `SUELDO` decimal(8,2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `categorias`
--

INSERT INTO `categorias` (`CATEGORIA`, `DESCRIPCION`, `SUELDO`) VALUES
(1, 'JEFE DE TALLER', '25000.00'),
(2, 'OFICIAL MECANICO', '18000.00'),
(3, 'AYUDANTE DE MECANICO', '7575.00');

-- --------------------------------------------------------

--
-- Table structure for table `mecanicos`
--

CREATE TABLE `mecanicos` (
  `MECANICO` smallint(5) UNSIGNED NOT NULL,
  `NOMBRE` varchar(30) NOT NULL,
  `APELLIDO` varchar(35) NOT NULL,
  `CATEGORIA` smallint(5) UNSIGNED DEFAULT NULL,
  `DIRECCION` varchar(50) DEFAULT NULL,
  `TELEFONO` varchar(15) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mecanicos`
--

INSERT INTO `mecanicos` (`MECANICO`, `NOMBRE`, `APELLIDO`, `CATEGORIA`, `DIRECCION`, `TELEFONO`) VALUES
(1, 'Juan', 'Pérez', 2, 'Calle 5 entre 4 y 6', '223067'),
(2, 'Manuel', 'Sosa', 3, 'Isla de Gorriti 1122', '099-325 410'),
(3, 'Mario', 'García', 1, 'Ayacucho 445', '233344'),
(4, 'Mario', 'González', 2, 'Calle Mar casi Oceano', '472365'),
(5, 'Pedro', 'Martínez', 3, 'Malvinas esq. Portugal', '417643'),
(6, 'Esteban', 'Quito', 2, 'calle 7 y 8', '334455');

--
-- Triggers `mecanicos`
--
DELIMITER $$
CREATE TRIGGER `mecanicosDelete` AFTER DELETE ON `mecanicos` FOR EACH ROW BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (user(), 'DELETE', now());
  END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `mecanicosInsert` AFTER INSERT ON `mecanicos` FOR EACH ROW BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (user(), 'INSERT', now());
  END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `mecanicosUpdate` AFTER UPDATE ON `mecanicos` FOR EACH ROW BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (user(), 'UPDATE', now());
  END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `registromecanico`
--

CREATE TABLE `registromecanico` (
  `nombre` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `operacion` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fechayhora` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `registromecanico`
--

INSERT INTO `registromecanico` (`nombre`, `operacion`, `fechayhora`) VALUES
('sandbox@localhost', 'INSERT', '2016-07-05 11:19:04'),
('sandbox@localhost', 'UPDATE', '2016-07-05 11:19:17'),
('sandbox@localhost', 'DELETE', '2016-07-05 11:19:27');

-- --------------------------------------------------------

--
-- Table structure for table `trabajos`
--

CREATE TABLE `trabajos` (
  `NROTRABAJO` smallint(5) UNSIGNED NOT NULL,
  `MATRICULA` varchar(10) NOT NULL,
  `ENTRADA` date NOT NULL,
  `PRECIO` decimal(10,2) DEFAULT NULL,
  `SALIDA` date DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trabajos`
--

INSERT INTO `trabajos` (`NROTRABAJO`, `MATRICULA`, `ENTRADA`, `PRECIO`, `SALIDA`) VALUES
(1, 'B-111258', '2014-08-01', '3500.00', '2014-08-15'),
(2, 'B-115850', '2014-08-01', '1220.00', '2014-08-18'),
(3, 'B-128680', '2014-08-01', '10.00', '2016-07-05'),
(4, 'B-104580', '2014-08-01', '3900.00', '2014-08-19'),
(5, 'B-130444', '2014-08-01', '2900.00', '2014-08-19'),
(6, 'B-101870', '2014-08-01', '10.00', '2016-07-05'),
(7, 'B-101781', '2014-08-01', '2550.00', '2014-08-18'),
(8, 'B-108789', '2014-08-01', '1555.00', '2014-08-28'),
(9, 'B-106795', '2016-06-13', '150.00', '2016-07-05'),
(10, 'B-105105', '2014-08-02', '950.00', '2014-08-28'),
(11, 'B-101128', '2014-08-02', '250.00', '2014-08-28'),
(12, 'A-125885', '2014-08-02', '4100.00', '2014-08-19'),
(13, 'C-8855', '2014-08-02', '2150.00', '2014-08-19'),
(14, 'B-14358', '2014-08-02', '1200.00', '2014-08-31'),
(15, 'B-10358', '2014-08-02', '4050.00', '2014-08-18'),
(16, 'B-103158', '2014-08-02', '3900.00', '2014-08-31'),
(17, 'B-104741', '2014-08-02', '6680.00', '2014-08-31'),
(18, 'B-106968', '2014-08-02', '2050.00', '2014-08-15'),
(19, 'B-102102', '2014-08-02', '1400.00', '2014-08-21'),
(20, 'B-123548', '2014-08-02', '2500.00', '2014-08-31'),
(21, 'B-130458', '2014-08-02', '2590.00', '2014-08-19'),
(22, 'B-101401', '2014-08-02', '2950.00', '2014-08-19'),
(23, 'B-99870', '2014-08-03', '450.00', '2014-08-28'),
(24, 'B-102108', '2014-08-03', '7000.00', '2014-08-19'),
(25, 'B-102109', '2014-08-03', '5980.00', '2014-08-31'),
(26, 'B-107954', '2014-08-03', '2800.00', '2014-08-21'),
(27, 'B-103157', '2014-08-03', '4580.00', '2014-08-18'),
(28, 'B-103159', '2016-06-13', '0.00', '0000-00-00'),
(29, 'B-104104', '2014-08-03', '850.00', '2014-08-15');

--
-- Triggers `trabajos`
--
DELIMITER $$
CREATE TRIGGER `TrabajoTerminado` AFTER UPDATE ON `trabajos` FOR EACH ROW BEGIN
    IF old.PRECIO = 0.00 AND new.SALIDA != 0.00
    THEN
      UPDATE trabajos_x_mecanicos
      SET TERMINADO = -1
      WHERE NROTRABAJO = new.NROTRABAJO;
    END IF;
  END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `trabajos_x_mecanicos`
--

CREATE TABLE `trabajos_x_mecanicos` (
  `NROTRABAJO` smallint(5) UNSIGNED NOT NULL,
  `MECANICO` smallint(5) UNSIGNED DEFAULT NULL,
  `DESCRIPCION` varchar(50) DEFAULT NULL,
  `TERMINADO` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trabajos_x_mecanicos`
--

INSERT INTO `trabajos_x_mecanicos` (`NROTRABAJO`, `MECANICO`, `DESCRIPCION`, `TERMINADO`) VALUES
(1, 3, 'Motor', -1),
(2, 3, 'Alineación', -1),
(3, 1, 'Electricidad', -1),
(4, 1, 'Pintura', -1),
(5, 1, 'Chapa', -1),
(6, 2, 'Pintura', 0),
(7, 3, 'Motor', -1),
(8, 5, 'Pintura', -1),
(9, 2, 'Alineación', -1),
(10, 1, 'Electricidad', -1),
(11, 3, 'Alineación', -1),
(12, 5, 'Pintura', -1),
(13, 4, 'Pintura', -1),
(14, 3, 'Electricidad', -1),
(15, 4, 'Chapa', -1),
(16, 3, 'Pintura', -1),
(17, 1, 'Chapa', -1),
(18, 2, 'Pintura', -1),
(19, 3, 'Electricidad', -1),
(20, 2, 'Pintura', -1),
(21, 1, 'Pintura', -1),
(22, 4, 'Motor', -1),
(23, 4, 'Alineación', -1),
(24, 5, 'Chapa', -1),
(25, 3, 'Chapa', -1),
(26, 2, 'Motor', -1),
(27, 5, 'Pintura', -1),
(28, 2, 'Chapa', 0),
(29, 2, 'Electricidad', -1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `autos`
--
ALTER TABLE `autos`
  ADD PRIMARY KEY (`MATRICULA`);

--
-- Indexes for table `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`CATEGORIA`);

--
-- Indexes for table `mecanicos`
--
ALTER TABLE `mecanicos`
  ADD PRIMARY KEY (`MECANICO`),
  ADD KEY `FK_categoria` (`CATEGORIA`);

--
-- Indexes for table `trabajos`
--
ALTER TABLE `trabajos`
  ADD PRIMARY KEY (`NROTRABAJO`),
  ADD KEY `FK_matricula` (`MATRICULA`);

--
-- Indexes for table `trabajos_x_mecanicos`
--
ALTER TABLE `trabajos_x_mecanicos`
  ADD PRIMARY KEY (`NROTRABAJO`),
  ADD KEY `FK_mecanico` (`MECANICO`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
