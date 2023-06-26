USE [AdventureWorks]
GO

SELECT * FROM dbo.Errores
INSERT INTO dbo.Errores
VALUES (GETDATE(), 'sa', 8134, 2, 16, 1,'Prueba',
'Error de prueba')

SELECT * FROM dbo.Sales
INSERT INTO dbo.Sales
VALUES ('MX', 'Norte', 123, GETDATE())

USE [Demo_Partition]
GO
SELECT * FROM ReporteEmpleados
SELECT * FROM Reportes
SELECT * FROM DatosReporte


USE [Demo_Partition]
GO
SELECT * FROM sys.fn_get_audit_file
('C:\Temp\Audit-20230623-122427_0FFA3F4B-A1DD-494B-A095-B303788784C5_0_133320182966760000.sqlaudit', DEFAULT, DEFAULT)

USE [AdventureWorks]
GO
SELECT * FROM sys.fn_get_audit_file
('C:\Temp\Audit-20230623-121250_5DF9CD15-6F5D-4373-998A-878B06F43491_0_133320176063630000.sqlaudit', DEFAULT, DEFAULT)
