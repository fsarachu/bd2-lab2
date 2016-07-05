-- Tarea 2:

DROP PROCEDURE IF EXISTS MarcaModelo;
CREATE PROCEDURE MarcaModelo(IN _marca VARCHAR(255), IN _modelo VARCHAR(255))
  BEGIN
    SELECT *
    FROM autos
    WHERE MARCA = _marca AND MODELO = _modelo;
  END;


-- Tarea 3

DROP PROCEDURE IF EXISTS MarcaModelo;
CREATE PROCEDURE MarcaModelo(IN _marca VARCHAR(255), IN _modelo VARCHAR(255))
  BEGIN
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
  END;


-- Tarea 4

DROP PROCEDURE IF EXISTS AgregoMecanico;
CREATE PROCEDURE AgregoMecanico(IN _nombre    VARCHAR(30), IN _apellido VARCHAR(35),
                                IN _direccion VARCHAR(50), IN _telefono VARCHAR(15))
  BEGIN
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
  END;


-- Tarea 5

DROP PROCEDURE IF EXISTS Taxi;
CREATE PROCEDURE Taxi()
  BEGIN
    UPDATE autos
    SET COLOR = 'Blanco'
    WHERE MARCA IN ('Opel', 'Fiat');
  END;


-- Tarea 6

DROP PROCEDURE IF EXISTS Aumento;
CREATE PROCEDURE Aumento(IN _importe decimal(8,2), IN _porcentaje decimal(5,2))
  BEGIN
    UPDATE categorias
    SET SUELDO = SUELDO * (1 + (_porcentaje/100))
    WHERE SUELDO < _importe;
  END;


-- Tarea 7

DROP PROCEDURE IF EXISTS EliminoUltimoMecanico;
CREATE PROCEDURE EliminoUltimoMecanico()
  BEGIN
    -- Variables
    DECLARE _id SMALLINT(5) UNSIGNED DEFAULT NULL;

    -- Obtengo id del último mecánico
    SELECT max(MECANICO)
    INTO _id
    FROM mecanicos;

    -- Borro el último mecánico
    DELETE FROM mecanicos
    WHERE MECANICO = _id;
  END;


-- Tarea 8

DROP FUNCTION IF EXISTS IVA;
CREATE FUNCTION IVA(_matricula VARCHAR(10))
  RETURNS DECIMAL(10, 2)
  BEGIN
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
  END;



