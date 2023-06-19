/*
Particiones
Es el proceso donde las tablas que son muy largas son divididas
en peque�as partes, estoo con la finalidad de que las consultas accedan solo
a la parte correspondiente, evitando el escaneo de toda la tabla.
*/

/*
Partici�n horizontal.
Va de la mano con una refactorizaci�n de la tabla. Se generan
tablas m�s peque�as (con menos columnas)
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
	WHILE @i < 100000000
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