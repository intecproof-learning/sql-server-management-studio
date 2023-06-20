/*
Particiones
Es el proceso donde las tablas que son muy largas son divididas
en pequeñas partes, estoo con la finalidad de que las consultas accedan solo
a la parte correspondiente, evitando el escaneo de toda la tabla / páginas
*/

/*
Partición horizontal.
Va de la mano con una refactorización de la tabla. Se generan
tablas más pequeñas (con menos columnas)
*/

USE [master]
CREATE DATABASE Demo_Partition
GO

USE [Demo_Partition]
GO

CREATE TABLE ReporteEmpleados
(
	reportID int IDENTITY (1, 1) NOT NULL PRIMARY KEY,
	reportName nvarchar(100),
	reportNumber nvarchar(20),
	reportDescription nvarchar(MAX)
)
GO

DECLARE @i int = 1
BEGIN TRAN
	WHILE @i < 1000000
	BEGIN
		INSERT INTO ReporteEmpleados
		(reportName, reportNumber, reportDescription)
		VALUES
		('Nombre', CONVERT(nvarchar(20), @i), REPLICATE('A', 1000))

		SET @i =  @i + 1
	END
	COMMIT TRAN
GO

SELECT * FROM ReporteEmpleados

SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT reportID, reportName, reportNumber
FROM ReporteEmpleados
WHERE reportNumber LIKE '%33%'
SET STATISTICS IO OFF
SET STATISTICS TIME OFF

CREATE TABLE DescripcionReporte
(
	reportID int PRIMARY KEY FOREIGN KEY
	REFERENCES ReporteEmpleados (reportID),
	reportDescription nvarchar(max)
)
GO

CREATE TABLE DatosReporte
(
	reportID int NOT NULL PRIMARY KEY,
	reportName nvarchar(100),
	reportNumber nvarchar(20)
)

INSERT INTO DatosReporte (reportID, reportName, reportNumber)
SELECT reportID, reportName, reportNumber FROM ReporteEmpleados

SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT reportID, reportName, reportNumber
FROM DatosReporte
WHERE reportNumber LIKE '%33%'
SET STATISTICS IO OFF
SET STATISTICS TIME OFF

------------------Particiones verticales
USE [master]
GO

ALTER DATABASE Demo_Partition
ADD FILEGROUP Enero
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Febrero
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Marzo
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Abril
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Mayo
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Junio
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Julio
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Agosto
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Septiembre
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Octubre
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Noviembre
GO
ALTER DATABASE Demo_Partition
ADD FILEGROUP Diciembre

USE [Demo_Partition]
GO

SELECT [name] FROM sys.filegroups WHERE [type] = 'FG'

USE [master]
GO

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartEne],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Ene.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Enero]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartFeb],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Feb.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Febrero]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartMar],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Mar.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Marzo]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartAbr],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Abr.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Abril]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartMay],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_May.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Mayo]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartJun],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Jun.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Junio]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartJul],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Jul.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Julio]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartAgo],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Ago.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Agosto]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartSep],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Sep.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Septiembre]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartOct],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Oct.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Octubre]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartNov],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Nov.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Noviembre]

ALTER DATABASE [Demo_Partition]
ADD FILE(
	NAME = [PartDic],
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Demo_Partition_Dic.ndf',
	SIZE = 3072 KB,
	MAXSIZE = UNLIMITED,
	FILEGROUTH = 1024 KB
) TO FILEGROUP [Diciembre]