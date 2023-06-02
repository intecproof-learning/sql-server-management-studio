-- Ejercicio 1
--Creación de tablas
CREATE TABLE [dbo].[DepartmentBackup](
	[DepartmentID] [smallint] NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[GroupName] [dbo].[Name] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
)
GO

CREATE TABLE [dbo].[DeleteOperations](
	[UserName] sysname NOT NULL,
	[ServerName] sysname NOT NULL,
	[ExecutionDate] datetime NOT NULL,
	[ExecutedQuery] nvarchar(max) NOT NULL
)
GO

CREATE TABLE [dbo].[EmployeeDepartmentHistoryBackup](
	[BusinessEntityID] [int] NOT NULL,
	[DepartmentID] [smallint] NOT NULL,
	[ShiftID] [tinyint] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NOT NULL,
)
GO
------------------------Trigger
CREATE OR ALTER TRIGGER HumanResources.Ejercicio_1
ON HumanResources.EmployeeDepartmentHistory
FOR DELETE
AS
	DELETE FROM HumanResources.Department
	WHERE DepartmentID IN (
		SELECT DepartmentID FROM deleted WHERE DepartmentID
		NOT IN (SELECT DepartmentID FROM
		HumanResources.EmployeeDepartmentHistory))

		INSERT INTO dbo.EmployeeDepartmentHistoryBackup
		SELECT * FROM deleted

		DECLARE @tmpTable TABLE
		(
			EventType nvarchar(50),
			[Parameters] int,
			EventInfo nvarchar(max)
		)
		
		INSERT INTO @tmpTable
		EXEC('DBCC INPUTBUFFER(@@SPID)')
		
		INSERT INTO [dbo].[DeleteOperations]
		SELECT ORIGINAL_LOGIN(), @@SERVERNAME, GETDATE(), EventInfo
		FROM @tmpTable
GO

CREATE OR ALTER TRIGGER HumanResources.Ejercicio_1_1
ON HumanResources.Department
FOR DELETE
AS
	INSERT INTO dbo.DepartmentBackup
	SELECT * FROM deleted
	
	DECLARE @tmpTable TABLE
	(
		EventType nvarchar(50),
		[Parameters] int,
		EventInfo nvarchar(max)
	)
	
	INSERT INTO @tmpTable
	EXEC('DBCC INPUTBUFFER(@@SPID)')
	
	INSERT INTO [dbo].[DeleteOperations]
	SELECT ORIGINAL_LOGIN(), @@SERVERNAME, GETDATE(), EventInfo
	FROM @tmpTable
GO



SELECT * FROM [dbo].[DeleteOperations]
SELECT * FROM dbo.EmployeeDepartmentHistoryBackup
SELECT * FROM [dbo].[DepartmentBackup]

SELECT * FROM HumanResources.Department
SELECT * FROM HumanResources.EmployeeDepartmentHistory

DELETE FROM HumanResources.EmployeeDepartmentHistory
WHERE DepartmentID = 1 AND BusinessEntityID = 4


--------------------------------------------------Ejercicio 2
USE master;  
GO  
CREATE LOGIN asd WITH PASSWORD = '3KHJ6dhx(0xVYsdf';  
GO  
GRANT VIEW SERVER STATE TO asd;  
GO

CREATE OR ALTER TRIGGER ValidarSesion
ON ALL SERVER
FOR LOGON
AS
	IF(
		ORIGINAL_LOGIN() = 'asd' AND
		(
			(DATEPART(HOUR, GETDATE()) BETWEEN 18 AND 24) OR
			(DATEPART(HOUR, GETDATE()) BETWEEN 0 AND 8)
		)
	)
	BEGIN
		ROLLBACK
	END
GO