-- Tarea 1

-- Creo tabla para el log
CREATE TABLE IF NOT EXISTS registromecanico (
  nombre     VARCHAR(30),
  operacion  VARCHAR(20),
  fechayhora DATETIME
);

-- Trigger para INSERT
DROP TRIGGER IF EXISTS mecanicosInsert;
CREATE TRIGGER mecanicosInsert AFTER INSERT ON mecanicos
FOR EACH ROW
  BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (user(), 'INSERT', now());
  END;

-- Trigger para UPDATE
DROP TRIGGER IF EXISTS mecanicosUpdate;
CREATE TRIGGER mecanicosUpdate AFTER UPDATE ON mecanicos
FOR EACH ROW
  BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (user(), 'UPDATE', now());
  END;

-- Trigger para DELETE
DROP TRIGGER IF EXISTS mecanicosDelete;
CREATE TRIGGER mecanicosDelete AFTER DELETE ON mecanicos
FOR EACH ROW
  BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (user(), 'DELETE', now());
  END;


-- Tarea 2

DROP TRIGGER IF EXISTS TrabajoTerminado;
CREATE TRIGGER TrabajoTerminado AFTER UPDATE ON trabajos
FOR EACH ROW
  BEGIN
    IF old.PRECIO = 0.00 AND new.SALIDA != 0.00
    THEN
      UPDATE trabajos_x_mecanicos
      SET TERMINADO = -1
      WHERE NROTRABAJO = new.NROTRABAJO;
    END IF;
  END;


