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
    VALUES (concat(new.NOMBRE, new.APELLIDO), 'INSERT', now());
  END;

-- Trigger para UPDATE
DROP TRIGGER IF EXISTS mecanicosUpdate;
CREATE TRIGGER mecanicosUpdate AFTER UPDATE ON mecanicos
FOR EACH ROW
  BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (concat(new.NOMBRE, new.APELLIDO), 'UPDATE', now());
  END;

-- Trigger para DELETE
DROP TRIGGER IF EXISTS mecanicosDelete;
CREATE TRIGGER mecanicosDelete AFTER DELETE ON mecanicos
FOR EACH ROW
  BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (concat(new.NOMBRE, new.APELLIDO), 'DELETE', now());
  END;



