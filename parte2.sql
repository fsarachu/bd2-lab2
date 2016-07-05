-- Tarea 1

-- Creo tabla para el log
CREATE TABLE IF NOT EXISTS registromecanico (
  nombre     VARCHAR(30),
  operacion  VARCHAR(20),
  fechayhora DATETIME
);

-- Trigger para INSERT
CREATE TRIGGER mecanicosInsert AFTER INSERT ON mecanicos
FOR EACH ROW
  BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (concat(new.NOMBRE, new.APELLIDO), 'INSERT', now());
  END;

-- Trigger para UPDATE
CREATE TRIGGER mecanicosUpdate AFTER UPDATE ON mecanicos
FOR EACH ROW
  BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (concat(new.NOMBRE, new.APELLIDO), 'UPDATE', now());
  END;

-- Trigger para DELETE
CREATE TRIGGER mecanicosDelete AFTER DELETE ON mecanicos
FOR EACH ROW
  BEGIN
    INSERT INTO registromecanico (nombre, operacion, fechayhora)
    VALUES (concat(new.NOMBRE, new.APELLIDO), 'DELETE', now());
  END;



