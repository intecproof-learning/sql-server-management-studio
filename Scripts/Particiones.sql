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
END TRAN

