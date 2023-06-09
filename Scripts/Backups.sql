BACKUP DATABASE AdventureWorks2019
TO DISK = 'C:\Temp\TestAW_2.bak'

BACKUP DATABASE AdventureWorks2019
TO DISK = 'C:\Temp\TestAW_1.bak'
WITH FORMAT, MEDIANAME = 'Native_SQLServerBackup',
NAME = 'Full-SQL AdventureWorks2019 backup',
DESCRIPTION = 'Full-SQL AdventureWorks2019 backup'

BACKUP DATABASE AdventureWorks2019
TO DISK = 'C:\Temp\TestAW_2.bak'
WITH FORMAT -- FORMAT INDICA QUE SI EXISTE EL MEDIA, LO ELIMINE/SOBREESCRIBA

BACKUP DATABASE AdventureWorks2019
TO DISK = 'C:\Temp\TestAW_3_1.bak',
DISK = 'C:\Temp\TestAW_3_2.bak',
DISK = 'C:\Temp\TestAW_3_3.bak',
DISK = 'C:\Temp\TestAW_3_4.bak',
DISK = 'C:\Temp\TestAW_3_5.bak',
DISK = 'C:\Temp\TestAW_3_6.bak'
WITH INIT, -- Le indica que genere un nuevo backup set
NAME = 'Full-SQL AdventureWorks2019 backup',
STATS = 5 -- Esto es un porcentaje de progreso, imprimirá cada 5% el estatus

BACKUP DATABASE AdventureWorks2019
TO DISK = 'C:\Temp\TestAW_4.bak'
MIRROR TO DISK = 'C:\Temp\Mirror\TestAW_4.bak'
WITH FORMAT

USE [master]
GO
CREATE CREDENTIAL [DbBackupCredential]
WITH IDENTITY = 'demobackpsqlacc'
, SECRET = 'iqZIT4XJPT5QSnW7iUOxL2EG8P4Q8ugW4K5dMsE971eik/jpKbskhB+dUnMCamV5/WUltNG/9Dew+AStAXd+Tg=='
GO


BACKUP DATABASE TestTrigger
TO URL =
'https://demobackpsqlacc.blob.core.windows.net/aw2019backups/TestAW_5_acc.bak'
WITH CREDENTIAL = 'DbBackupCredential', STATS


---------Cambios complejos

ALTER TABLE dbo.Sales
ADD extraColumn int NULL

SELECT * FROM dbo.Sales

ALTER TABLE dbo.Usuarios
ADD extraColumn int NULL

UPDATE dbo.Usuarios SET extraColumn = 12

ALTER TABLE dbo.Usuarios
ALTER COLUMN extraColumn int NOT NULL

BACKUP DATABASE AdventureWorks2019
TO DISK = 'C:\Temp\TestAW_7.bak'
WITH FORMAT,
MEDIANAME = 'Native_SQLServerBackup',
MEDIADESCRIPTION = 'Native_SQLServerBackup_Desc',
NAME = 'Full-SQL AdventureWorks2019 backup',
DESCRIPTION = 'Full-SQL AdventureWorks2019 backup'

BACKUP DATABASE AdventureWorks2019
TO DISK = 'C:\Temp\TestAW_7.bak'
WITH MEDIANAME = 'Native_SQLServerBackup',
MEDIADESCRIPTION = 'Native_SQLServerBackup_Desc',
NAME = 'Full-SQL AdventureWorks2019 backup_2',
DESCRIPTION = 'Full-SQL AdventureWorks2019 backup_2'

BACKUP DATABASE AdventureWorks2019
TO DISK = 'C:\Temp\TestAW_6.bak'
WITH FORMAT,
MEDIANAME = 'Native_SQLServerBackup_2',
MEDIADESCRIPTION = 'Native_SQLServerBackup_Desc_2',
NAME = 'Full-SQL AdventureWorks2019 backup_3',
DESCRIPTION = 'Full-SQL AdventureWorks2019 backup_3'