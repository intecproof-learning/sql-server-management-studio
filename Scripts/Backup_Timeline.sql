--1.- Verificar que mi base de datos esté en modo recovery full
--2.- Generar un backup completo
BACKUP DATABASE AdventureWorks
TO DISK = 'C:\Temp\AW_DR.bak'
WITH FORMAT,
MEDIANAME = 'Backup_Timeline',
MEDIADESCRIPTION = 'Media que contiene backups en  modo full',
NAME = 'Primer_Respaldo',
DESCRIPTION = 'Primer full backup'

DECLARE @counter int = 5
WHILE @counter < 10
BEGIN
	INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
	('Mexico', 'Norte', @counter, GETDATE())

	INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
	('Mexico', 'Sur', @counter, GETDATE())

	INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
	('Mexico', 'Este', @counter, GETDATE())

	INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
	('Mexico', 'Oeste', @counter, GETDATE())

	SET @counter =	@counter + 1
	WAITFOR DELAY '00:02:00'
END

BACKUP LOG AdventureWorks
TO DISK = 'C:\Temp\AW_DR.bak'
WITH
MEDIANAME = 'Backup_Timeline',
MEDIADESCRIPTION = 'Media que contiene backups en  modo full',
NAME = 'Segundo_Respaldo',
DESCRIPTION = 'Primer log backup'

SELECT * FROM dbo.Sales