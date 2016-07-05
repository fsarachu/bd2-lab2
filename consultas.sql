-- Tarea 2:

DROP PROCEDURE IF EXISTS MarcaModelo;
CREATE PROCEDURE MarcaModelo(IN _marca VARCHAR(255), IN _modelo VARCHAR(255))
  BEGIN
    SELECT *
    FROM autos
    WHERE MARCA = _marca AND MODELO = _modelo;
  END;


-- Tarea 3


