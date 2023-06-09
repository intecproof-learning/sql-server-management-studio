--1.- Verificar que mi base de datos esté en modo recovery full
--2.- Generar un backup completo
BACKUP DATABASE AdventureWorks
TO DISK = 'C:\Temp\AW_DR.bak'
WITH FORMAT,
MEDIANAME = 'Backup_Timeline',
MEDIADESCRIPTION = 'Media que contiene backups en  modo full',
NAME = 'Primer_Respaldo',
DESCRIPTION = 'Primer full backup'

DECLARE @counter int = 10
WHILE @counter < 15
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

SET @counter = 15
WHILE @counter < 20
BEGIN
	BEGIN TRANSACTION Insert_Norte_Sur
	WITH MARK 'Insercion de ventas en Mexico Norte y Sur'
		INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
		('Mexico', 'Norte', @counter, GETDATE())

		INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
		('Mexico', 'Sur', @counter, GETDATE())
	COMMIT TRANSACTION Insert_Norte_Sur

	BEGIN TRANSACTION Insert_Este_Oeste
	WITH MARK 'Insercion de ventas en Mexico Este y Oeste'
		INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
		('Mexico', 'Este', @counter, GETDATE())

		INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
		('Mexico', 'Oeste', @counter, GETDATE())
	COMMIT TRANSACTION Insert_Este_Oeste

	SET @counter =	@counter + 1
	WAITFOR DELAY '00:02:00'
END

BACKUP LOG AdventureWorks
TO DISK = 'C:\Temp\AW_DR.bak'
WITH
MEDIANAME = 'Backup_Timeline',
MEDIADESCRIPTION = 'Media que contiene backups en  modo full',
NAME = 'Tercer_Respaldo',
DESCRIPTION = 'Segundo log backup'

BEGIN TRANSACTION Insert_Norte_Sur
WITH MARK 'Insercion de ventas en Mexico Norte y Sur'
	INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
	('Mexico', 'Norte', 201, GETDATE())

	INSERT INTO dbo.Sales (country, region, sales, fecha) VALUES
	('Mexico', 'Sur', 201, GETDATE())
COMMIT TRANSACTION Insert_Norte_Sur

BACKUP DATABASE AdventureWorks
TO DISK = 'C:\Temp\AW_DR.bak'
WITH DIFFERENTIAL,
MEDIANAME = 'Backup_Timeline',
MEDIADESCRIPTION = 'Media que contiene backups en  modo full',
NAME = 'Cuarto_Respaldo',
DESCRIPTION = 'Primer diferencial'

BACKUP LOG AdventureWorks
TO DISK = 'C:\Temp\AW_DR.bak'
WITH
MEDIANAME = 'Backup_Timeline',
MEDIADESCRIPTION = 'Media que contiene backups en  modo full',
NAME = 'Tercer_Respaldo',
DESCRIPTION = 'Segundo log backup'

SELECT * FROM dbo.Sales