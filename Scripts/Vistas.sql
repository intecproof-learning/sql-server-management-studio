CREATE PROCEDURE CrearTablaTrabajo
AS
BEGIN
	DROP TABLE dbo.Resultados
	CREATE TABLE dbo.Resultados
	(
		id int NOT NULL PRIMARY KEY,
		tipo nvarchar(50) NOT NULL,
		resultado int NOT NULL
	)
	
	INSERT INTO Resultados (id, tipo, resultado)
	VALUES (1, 'Tipo 1', 2),
	(2, 'Tipo 1', 2),
	(3, 'Tipo 1', 2),
	(4, 'Tipo 2', 2),
	(5, 'Tipo 2', 2),
	(6, 'Tipo 2', 2),
	(7, 'Tipo 1', 2),
	(8, 'Tipo 1', 2),
	(9, 'Tipo 2', 2),
	(10, 'Tipo 2', 2),
	(11, 'Tipo 3', 2),
	(12, 'Tipo 3', 2),
	(13, 'Tipo 3', 2),
	(14, 'Tipo 3', 2),
	(15, 'Tipo 3', 2),
	(16, 'Tipo 4', 2),
	(17, 'Tipo 4', 2),
	(18, 'Tipo 4', 2),
	(19, 'Tipo 4', 2),
	(20, 'Tipo 4', 2),
	(21, 'Tipo 5', 2),
	(22, 'Tipo 5', 2),
	(23, 'Tipo 5', 2),
	(24, 'Tipo 5', 2),
	(25, 'Tipo 5', 2)
END
GO

EXEC CrearTablaTrabajo
GO

CREATE VIEW VistaNormal
AS
	SELECT id, tipo, resultado
	FROM dbo.Resultados
GO

SELECT * FROM VistaNormal
GO

ALTER TABLE dbo.Resultados DROP COLUMN resultado
GO

SELECT * FROM dbo.Resultados
GO

DROP VIEW VistaNormal
GO

EXEC CrearTablaTrabajo
GO

----------------------------SCHEMABINDING
CREATE VIEW VistaSchemaBinding
WITH SCHEMABINDING
AS
	SELECT id, tipo, resultado
	FROM dbo.Resultados
GO

SELECT * FROM VistaSchemaBinding
GO

SELECT * FROM dbo.Resultados
GO

ALTER TABLE dbo.Resultados DROP COLUMN resultado
GO
------------------------------CHECL OPTION
EXEC CrearTablaTrabajo
GO

CREATE VIEW VistaSchemaBindingEdit
WITH SCHEMABINDING
AS
	SELECT id, tipo, resultado
	FROM dbo.Resultados
GO

SELECT * FROM VistaSchemaBindingEdit
GO

INSERT INTO VistaSchemaBindingEdit (id, tipo, resultado)
VALUES(26, 'Tipo 6', 2)
GO

UPDATE VistaSchemaBindingEdit SET resultado = 3
GO

ALTER VIEW VistaSchemaBindingEdit
WITH SCHEMABINDING
AS
	SELECT id, tipo
	FROM dbo.Resultados
GO

INSERT INTO VistaSchemaBindingEdit (id, tipo)
VALUES(27, 'Tipo 6')
GO

UPDATE VistaSchemaBindingEdit SET resultado = 2
GO

SELECT * FROM VistaSchemaBindingEdit
GO

SELECT * FROM dbo.Resultados
GO

ALTER TABLE dbo.Resultados ADD CONSTRAINT [DF_Resultados(resultado)]
DEFAULT 2 FOR resultado
GO