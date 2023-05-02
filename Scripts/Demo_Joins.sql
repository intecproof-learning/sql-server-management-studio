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