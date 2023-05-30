----------------------------------TRIGGERS
--https://learn.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver16
--DML Trigger (Data Manipulation Language)
CREATE OR ALTER TRIGGER Recordatorio
ON dbo.Resultados
--AFTER INSERT, UPDATE
--INSTEAD OF INSERT, UPDATE
FOR INSERT, UPDATE
AS
	RAISERROR('Ejemplo de trigger', 16, 101);
GO

UPDATE dbo.Resultados SET resultado = 8
GO

INSERT INTO dbo.Resultados (id, tipo, resultado)
VALUES(29, 'Tipo 6', 2)
GO

SELECT * FROM dbo.Resultados
GO

------------------------------------------------------
--DML Trigger
sp_configure 'show advanced options', 1
GO
RECONFIGURE;
GO
sp_configure 'Database Mail XPs', 1
GO
RECONFIGURE;
GO

CREATE TRIGGER Alerta
ON dbo.Resultados
AFTER INSERT, UPDATE, DELETE
AS
	EXEC msdb.dbo.sp_send_dbmail
	@profile_name = 'Demo_Mail',
	@recipients = 'abraham_cha88@hotmail.com',
	@body = 'Hubo modificaciones en la tabla dbo.Resultados',
	@subject = 'Alerta SQL Server'
GO

UPDATE dbo.Resultados SET resultado = 1
GO

INSERT INTO dbo.Resultados (id, tipo, resultado)
VALUES(30, 'Tipo 6', 2)
GO

SELECT * FROM dbo.Resultados
GO

--------------------------------------
--DML TRIGGER
CREATE TRIGGER Prevenirinsercion ON dbo.Resultados
AFTER INSERT
AS
	IF EXISTS (SELECT 1 FROM inserted WHERE resultado < 2)
	BEGIN
		RAISERROR ('No puedes insertar un valor menor a 2', 16, 1)
		<
	END
GO

INSERT INTO dbo.Resultados (id, tipo, resultado)
VALUES(32, 'Tipo 7', 1)
GO

SELECT * FROM dbo.Resultados
GO