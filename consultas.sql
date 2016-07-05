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


