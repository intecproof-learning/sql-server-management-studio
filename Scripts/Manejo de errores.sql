--https://learn.microsoft.com/es-mx/sql/relational-databases/errors-events/database-engine-error-severities?view=sql-server-ver16


BEGIN TRY
	select 4/2
	SELECT 6/3
	SELECT 1/0
	SELECT 'Terminado'
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber,
	ERROR_LINE() AS ERRORLINE,
	ERROR_SEVERITY() AS ERRORSEVERITY,
	ERROR_STATE() AS ERRORSTATE,
	ERROR_PROCEDURE() AS ERRORPROCEDURE,
	ERROR_MESSAGE() AS ERRORMESSAGE
END CATCH

BEGIN TRY
	SELECT * FROM TablaQueNoExiste
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber,
	ERROR_LINE() AS ErrorLine,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_MESSAGE() AS ErrorMessage
	INTO Errores

	SELECT * FROM Errores
END CATCH

BEGIN TRY
	SELECT 1/0
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber,
	ERROR_LINE() AS ErrorLine,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_MESSAGE() AS ErrorMessage
	INTO Errores
END CATCH


BEGIN TRY
	SELECT 1/0
END TRY
BEGIN CATCH
	IF EXISTS (SELECT * FROM sys.objects
	WHERE OBJECT_ID = OBJECT_ID(N'[Errores]') AND [type] = N'U')
	BEGIN
		INSERT INTO Errores
		SELECT
		GETDATE() AS [Execution Date],
		SUSER_NAME() AS [User Name],
		ERROR_NUMBER() AS [Error Number],
		ERROR_LINE() AS [Error Line],
		ERROR_SEVERITY() AS [Error Severity],
		ERROR_STATE() AS [Error State],
		ERROR_PROCEDURE() AS [Error Procedure],
		ERROR_MESSAGE() AS [Error Message]
	END
	ELSE 
	BEGIN
		SELECT
		GETDATE() AS [Execution Date],
		SUSER_NAME() AS [User Name],
		ERROR_NUMBER() AS [Error Number],
		ERROR_LINE() AS [Error Line],
		ERROR_SEVERITY() AS [Error Severity],
		ERROR_STATE() AS [Error State],
		ERROR_PROCEDURE() AS [Error Procedure],
		ERROR_MESSAGE() AS [Error Message]
		INTO Errores
	END
END CATCH

BEGIN TRY
	SELECT 1/0
END TRY
BEGIN CATCH
	IF EXISTS (SELECT * FROM sys.objects
	WHERE OBJECT_ID = OBJECT_ID(N'[Errores]') AND [type] = N'U')
	BEGIN
		INSERT INTO Errores
		SELECT
		GETDATE() AS [Execution Date],
		SUSER_NAME() AS [User Name],
		ERROR_NUMBER() AS [Error Number],
		ERROR_LINE() AS [Error Line],
		ERROR_SEVERITY() AS [Error Severity],
		ERROR_STATE() AS [Error State],
		ERROR_PROCEDURE() AS [Error Procedure],
		ERROR_MESSAGE() AS [Error Message]
	END
	ELSE 
	BEGIN
		SELECT
		GETDATE() AS [Execution Date],
		SUSER_NAME() AS [User Name],
		ERROR_NUMBER() AS [Error Number],
		ERROR_LINE() AS [Error Line],
		ERROR_SEVERITY() AS [Error Severity],
		ERROR_STATE() AS [Error State],
		ERROR_PROCEDURE() AS [Error Procedure],
		ERROR_MESSAGE() AS [Error Message]
		INTO Errores
	END

	;THROW;
END CATCH

BEGIN TRY
	DECLARE @dividendo int = 1
	DECLARE @divisor int = 0

	IF @divisor = 0
	BEGIN
		--SELECT * FROM sys.messages WHERE message_id = 8134
		;THROW 50004, 'No es posible que el divisor dea 0', 1;
	END

	SELECT @dividendo/@divisor
END TRY
BEGIN CATCH
	IF EXISTS (SELECT * FROM sys.objects
	WHERE OBJECT_ID = OBJECT_ID(N'[Errores]') AND [type] = N'U')
	BEGIN
		INSERT INTO Errores
		SELECT
		GETDATE() AS [Execution Date],
		SUSER_NAME() AS [User Name],
		ERROR_NUMBER() AS [Error Number],
		ERROR_LINE() AS [Error Line],
		ERROR_SEVERITY() AS [Error Severity],
		ERROR_STATE() AS [Error State],
		ERROR_PROCEDURE() AS [Error Procedure],
		ERROR_MESSAGE() AS [Error Message]
	END
	ELSE 
	BEGIN
		SELECT
		GETDATE() AS [Execution Date],
		SUSER_NAME() AS [User Name],
		ERROR_NUMBER() AS [Error Number],
		ERROR_LINE() AS [Error Line],
		ERROR_SEVERITY() AS [Error Severity],
		ERROR_STATE() AS [Error State],
		ERROR_PROCEDURE() AS [Error Procedure],
		ERROR_MESSAGE() AS [Error Message]
		INTO Errores
	END

	;THROW;
END CATCH

CREATE TABLE Usuarios
(
	id int PRIMARY KEY IDENTITY(1, 1),
	nombre nvarchar(50) NOT NULL,
	idRol int NOT NULL
)

BEGIN TRAN --TRAN O TRANSACTION ES LO MISMO --Esto es estructura de desarrollo
BEGIN TRY
	INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
	INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)
	INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', 3)
	INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', 4)

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SELECT * FROM Usuarios


BEGIN TRY
	BEGIN TRAN
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', 3)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', 4)

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SELECT * FROM Usuarios

BEGIN TRY
	BEGIN TRAN
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', NULL)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', 4)
	COMMIT TRANSACTION

		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 5', 5)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 6', 6)
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SELECT * FROM Usuarios -- 8 filas

BEGIN TRY
	BEGIN TRAN
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', 3)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', 4)
	COMMIT TRANSACTION

		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 5', 5)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 6', 6)
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SELECT * FROM Usuarios

BEGIN TRY
	INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 5', 5)
	INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 6', 6)
	BEGIN TRAN
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', NULL)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', 4)
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SELECT * FROM Usuarios --14 filas

BEGIN TRY
	BEGIN TRAN
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', 3)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', 4)
	COMMIT TRANSACTION

	INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 5', 5)
	INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 6', NULL)
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SELECT * FROM Usuarios --16 filas

BEGIN TRY
	BEGIN TRAN TRN1
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', 3)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', 4)
	COMMIT TRANSACTION TRN1
END TRY
BEGIN CATCH
	ROLLBACK TRAN TRN1
END CATCH
SELECT * FROM Usuarios --21 filas

BEGIN TRY
	BEGIN TRAN TRN1
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)
	COMMIT TRANSACTION TRN1

	BEGIN TRAN TRN2
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', 3)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', 4)
	COMMIT TRANSACTION TRN2	
END TRY
BEGIN CATCH
	ROLLBACK TRAN TRN1
	ROLLBACK TRAN TRN2
END CATCH
SELECT * FROM Usuarios --25

BEGIN TRY
	BEGIN TRAN TRN1
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)
	COMMIT TRANSACTION TRN1

	BEGIN TRAN TRN2
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', 3)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', NULL)
	COMMIT TRANSACTION TRN2	
END TRY
BEGIN CATCH
	ROLLBACK TRAN TRN1
	ROLLBACK TRAN TRN2
END CATCH
SELECT * FROM Usuarios --29

BEGIN TRY
	BEGIN TRAN TRN1
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)
	COMMIT TRANSACTION TRN1

	BEGIN TRAN TRN2
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', 3)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', NULL)
	COMMIT TRANSACTION TRN2	
END TRY
BEGIN CATCH
	--SELECT * FROM sys.dm_tran_active_transactions
	IF (SELECT COUNT(*) FROM sys.dm_tran_active_transactions
		WHERE [name] = 'TRN1') > 0
		ROLLBACK TRAN TRN1

	IF (SELECT COUNT(*) FROM sys.dm_tran_active_transactions
		WHERE [name] = 'TRN2') > 0
		ROLLBACK TRAN TRN2
END CATCH
SELECT * FROM Usuarios --31

BEGIN TRY
	BEGIN TRAN TRN1
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 1', 1)
		INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 2', 2)

		BEGIN TRAN TRN2
			INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 3', 3)
			INSERT INTO Usuarios (nombre, idRol) VALUES ('Usuario 4', NULL)
		COMMIT TRANSACTION TRN2
	COMMIT TRANSACTION TRN1	
END TRY
BEGIN CATCH
	--SELECT * FROM sys.dm_tran_active_transactions
	IF (SELECT COUNT(*) FROM sys.dm_tran_active_transactions
		WHERE [name] = 'TRN1') > 0
		ROLLBACK TRAN TRN1

	IF (SELECT COUNT(*) FROM sys.dm_tran_active_transactions
		WHERE [name] = 'TRN2') > 0
		ROLLBACK TRAN TRN2
END CATCH
SELECT * FROM Usuarios --31

--Ejercicio
ALTER PROCEDURE usp_Ocurrencia
@cadena1 nvarchar(50),
@cadena2 nvarchar(5)
AS
	IF @cadena1 IS NULL OR @cadena1 = ''
		THROW 50001, 'El valor de cadena 1 no puede ser nulo ni vacío', 1;
	
	IF @cadena2 IS NULL OR @cadena2 = ''
		THROW 50001, 'El valor de cadena 2 no puede ser nulo ni vacío', 1;
	
	DECLARE @tmp nvarchar(1) = LEFT(@cadena2, 1)
	SET @cadena2 = REPLACE(@cadena2, @tmp, '')
	SELECT COUNT(*) FROM string_split(@cadena1, @tmp)
	WHERE [value] LIKE CONCAT(@cadena2,'%')
GO


DECLARE @cadena1 nvarchar(50) = 'abdcabcabcdabcdacdab'
DECLARE @cadena2 nvarchar(5) = 'ab'

PRINT @cadena1
PRINT @cadena2

DECLARE @tmp nvarchar(1) = LEFT(@cadena2, 1)
PRINT @cadena2
PRINT @tmp
SET @cadena2 = REPLACE(@cadena2, @tmp, '')
PRINT @cadena2
PRINT @tmp
SELECT * FROM string_split(@cadena1, @tmp)

SELECT COUNT(*) FROM string_split(@cadena1, @tmp)
WHERE [value] LIKE CONCAT(@cadena2,'%')

EXEC usp_Ocurrencia 'abdcabcabcdabcdacdab', ''