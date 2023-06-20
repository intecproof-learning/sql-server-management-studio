/*
Particiones
Es el proceso donde las tablas que son muy largas son divididas
en pequeñas partes, estoo con la finalidad de que las consultas accedan solo
a la parte correspondiente, evitando el escaneo de toda la tabla.
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
	WHILE @i < 100000
	BEGIN
		INSERT INTO ReporteEmpleados
		(reportName, reportNumber, reportDescription)
		VALUES
		('Nombre', CONVERT(nvarchar(20), @i), REPLICATE('A', 1000))

		SET @i =  @i + 1
	END
	COMMIT TRAN
GO

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