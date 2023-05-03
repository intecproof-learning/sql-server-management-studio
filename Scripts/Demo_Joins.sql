USE [master]
GO

CREATE DATABASE [Demo_Joins]
GO

USE [Demo_Joins]
GO

CREATE TABLE [dbo].[Conjunto_A]
(
	[conjunto_AID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
	[descripcion] [nvarchar](50) NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
)
GO

CREATE TABLE [dbo].[Conjunto_B](
	[conjunto_BID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[conjunto_AID] [int] NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
	[cantidad] [int] NOT NULL,
	[precio] [money] NOT NULL,
)
GO

SELECT * FROM Conjunto_A
SELECT * FROM Conjunto_B

SELECT * FROM Conjunto_A, Conjunto_B

SELECT * FROM Conjunto_A AS a INNER JOIN Conjunto_B AS b
ON a.conjunto_AID = b.conjunto_AID

SELECT * FROM Conjunto_A AS a, Conjunto_B AS b
WHERE a.conjunto_AID = b.conjunto_BID

SELECT * FROM Conjunto_A AS a INNER JOIN Conjunto_B AS b
ON a.nombre = b.nombre

SELECT * FROM Conjunto_A AS a LEFT JOIN Conjunto_B AS b
ON a.nombre = b.nombre 

SELECT * FROM Conjunto_A AS a RIGHT JOIN Conjunto_B AS b
ON a.nombre = b.nombre

SELECT * FROM Conjunto_A AS a LEFT JOIN Conjunto_B AS b
ON a.nombre = b.nombre
WHERE b.nombre IS NULL

---------------------Clase martes 2 de mayo de 2023-----------------------
SELECT * FROM Conjunto_A
WHERE conjunto_AID = 20
SELECT * FROM Conjunto_B
WHERE conjunto_AID = 20

ALTER TABLE dbo.Conjunto_B
ADD CONSTRAINT [FK_CB-CA] FOREIGN KEY (conjunto_AID)
REFERENCES dbo.Conjunto_A (conjunto_AID)

--eSTE QUERY ES LO MISMO QUE EL DE ARRIBA
ALTER TABLE dbo.Conjunto_B
ADD CONSTRAINT [FK_CB-CA] FOREIGN KEY (conjunto_AID)
REFERENCES dbo.Conjunto_A (conjunto_AID)
ON DELETE NO ACTION
ON UPDATE NO ACTION

SELECT * FROM Conjunto_A
WHERE conjunto_AID = 20
SELECT * FROM Conjunto_B
WHERE conjunto_AID = 20

ALTER TABLE Conjunto_B
NOCHECK CONSTRAINT [FK_CB-CA]

UPDATE Conjunto_A SET conjunto_AID = 10000
WHERE conjunto_AID = 20

SELECT * FROM Conjunto_A WHERE conjunto_AID IN (20, 10000)
SELECT * FROM Conjunto_B WHERE conjunto_AID IN (20, 10000)

DELETE Conjunto_A WHERE conjunto_AID = 10000

ALTER TABLE Conjunto_B
CHECK CONSTRAINT [FK_CB-CA]

ALTER TABLE dbo.Conjunto_B
DROP CONSTRAINT [FK_CB-CA]

--------------------------------------------------------------------
SELECT * FROM Conjunto_A
WHERE conjunto_AID = 22
SELECT * FROM Conjunto_B
WHERE conjunto_AID = 22

DELETE FROM Conjunto_B WHERE conjunto_AID = 20

ALTER TABLE dbo.Conjunto_B
ADD CONSTRAINT [FK_CB-CA] FOREIGN KEY (conjunto_AID)
REFERENCES dbo.Conjunto_A (conjunto_AID)
ON DELETE CASCADE
ON UPDATE CASCADE

UPDATE Conjunto_A SET conjunto_AID = 10000
WHERE conjunto_AID = 21

DELETE Conjunto_A WHERE conjunto_AID = 10000

UPDATE Conjunto_B SET conjunto_AID = 10000
WHERE conjunto_AID = 22

DELETE Conjunto_B WHERE conjunto_AID = 22

ALTER TABLE dbo.Conjunto_B
DROP CONSTRAINT [FK_CB-CA]
--------------------------------------------------------------
SELECT * FROM Conjunto_A
WHERE conjunto_AID = 23
SELECT * FROM Conjunto_B
WHERE conjunto_AID = 23

ALTER TABLE dbo.Conjunto_B
ADD CONSTRAINT [FK_CB-CA] FOREIGN KEY (conjunto_AID)
REFERENCES dbo.Conjunto_A (conjunto_AID)
ON DELETE SET NULL
ON UPDATE SET NULL

ALTER TABLE Conjunto_B ALTER COLUMN conjunto_AID int NULL

UPDATE Conjunto_A SET conjunto_AID = 10000
WHERE conjunto_AID = 23

SELECT * FROM Conjunto_A
WHERE conjunto_AID IN (10000, 24)
SELECT * FROM Conjunto_B
WHERE conjunto_AID IS NULL OR conjunto_AID = 24

DELETE Conjunto_A WHERE conjunto_AID = 24

DELETE Conjunto_B WHERE conjunto_AID IS NULL
DELETE Conjunto_A WHERE conjunto_AID = 10000

ALTER TABLE dbo.Conjunto_B
DROP CONSTRAINT [FK_CB-CA]

ALTER TABLE Conjunto_B
ALTER COLUMN conjunto_AID int NOT NULL

-------------------------------------------------------------
SELECT * FROM Conjunto_A
WHERE conjunto_AID = 10000
SELECT * FROM Conjunto_B
WHERE conjunto_AID = 10000

ALTER TABLE Conjunto_B
ADD CONSTRAINT [DEFAULT(conjunto_AID)]
DEFAULT 10000 FOR conjunto_AID

ALTER TABLE dbo.Conjunto_B
ADD CONSTRAINT [FK_CB-CA] FOREIGN KEY (conjunto_AID)
REFERENCES dbo.Conjunto_A (conjunto_AID)
ON DELETE SET DEFAULT
ON UPDATE SET DEFAULT

UPDATE Conjunto_A SET conjunto_AID = 10000
WHERE conjunto_AID = 25

DELETE Conjunto_A WHERE conjunto_AID = 26

ALTER TABLE Conjunto_B
ALTER COLUMN conjunto_AID int NOT NULL

SELECT * FROM Empleado
SELECT * FROM Empleado AS e1 INNER JOIN Empleado AS e2
ON e1.id = e2.idManager
SELECT * FROM Empleado AS e1 LEFT JOIN Empleado AS e2
ON e1.id = e2.idManager

--Cursores
--CTEs = Common Table Expressions

DECLARE @id int
DECLARE EmpData CURSOR FOR SELECT id FROM Empleado
OPEN EmpData
FETCH NEXT FROM EmpData INTO @id
WHILE @@fetch_status = 0
BEGIN
	SELECT 'Algo'
END
CLOSE EmpData
DEALLOCATE EmpData