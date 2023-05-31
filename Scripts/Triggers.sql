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
		ROLLBACK TRANSACTION
	END
GO

INSERT INTO dbo.Resultados (id, tipo, resultado)
VALUES(32, 'Tipo 7', 1)
GO

SELECT * FROM dbo.Resultados
GO

--------------------------------------------------------
GO
ALTER PROCEDURE dbo.PruebaCommitTrigger
AS
BEGIN
	BEGIN TRY
		--BEGIN TRAN TR1
			INSERT INTO dbo.Resultados(tipo, resultado)
			VALUES('Tipo SP', 2)
		--COMMIT TRAN TR1

		--BEGIN TRAN TR2
			--INSERT INTO dbo.Resultados(tipo, resultado)
			--VALUES('Tipo SP', NULL)
		--COMMIT TRAN TR2
	END TRY
	BEGIN CATCH
		--IF (SELECT COUNT(*) FROM sys.dm_tran_active_transactions
		--	WHERE [name] = 'TR1') > 0
		--	ROLLBACK TRAN TR1

		--IF (SELECT COUNT(*) FROM sys.dm_tran_active_transactions
		--	WHERE [name] = 'TR2') > 0
		--	ROLLBACK TRAN TR2
	END CATCH
END
GO

EXEC dbo.PruebaCommitTrigger
GO

SELECT * FROM dbo.Resultados
GO

CREATE TRIGGER DemoSP ON Production.Culture
AFTER INSERT, UPDATE
AS
	EXEC dbo.PruebaCommitTrigger
GO

UPDATE Production.Culture SET ModifiedDate = GETDATE()
GO

----------------------------------------------------------------
--https://learn.microsoft.com/en-us/sql/relational-databases/triggers/ddl-event-groups?view=sql-server-ver16
CREATE TRIGGER DemoBaseDatos
ON DATABASE FOR DROP_TABLE
AS
GO