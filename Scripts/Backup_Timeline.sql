--1.- Verificar que mi base de datos est� en modo recovery full
--2.- Generar un backup completo
BACKUP DATABASE AdventureWorks
TO DISK = 'C:\Temp\AW_DR.bak'
WITH FORMAT,
MEDIANAME = 'Backup_Timeline_Simple',
MEDIADESCRIPTION = 'Media que contiene backups en  modo simple',
NAME = 'Primer_Respaldo',
DESCRIPTION = 'Primer full backup'

DECLARE @counter int = 0
WHILE @counter < 5
BEGIN
	INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
	('Mexico', 'Norte', @counter, GETDATE())

	INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
	('Mexico', 'Sur', @counter, GETDATE())

	INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
	('Mexico', 'Este', @counter, GETDATE())

	INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
	('Mexico', 'Oeste', @counter, GETDATE())

END