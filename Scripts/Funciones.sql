CREATE FUNCTION ufn_GetPersonList()
RETURNS TABLE
AS
RETURN
(
	SELECT * FROM Person.Person
)
GO

SELECT * FROM ufn_GetPersonList()
GO

CREATE FUNCTION ufn_ConcatName
(
	@firstName nvarchar(50),
	@middleName nvarchar(50),
	@lastName nvarchar(50)
)
RETURNS nvarchar(150)
AS
BEGIN

RETURN (SELECT CONCAT(@firstName, @middleName, @lastName))
END
GO

SELECT dbo.ufn_ConcatName('A', 'B', 'C')
SELECT
dbo.ufn_ConcatName(FirstName, MiddleName, LastName) AS FullName,
BusinessEntityID,
PersonType
FROM Person.Person

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'clr enable', 1;
RECONFIGURE;

EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;

CREATE ASSEMBLY SQLCLRDemo2
FROM 'C:\Temp\CLRFunctionsSQL.dll'
GO

CREATE FUNCTION ObtenerHoraActualISO()
RETURNS nvarchar(20)
EXTERNAL NAME SQLCLRDemo2.SQLFunctions.ObtenerHoraActualISO

SELECT dbo.ObtenerHoraActualISO()

ALTER ASSEMBLY SQLCLRDemo2
FROM 'C:\Temp\CLRFunctionsSQL.dll'
GO

CREATE FUNCTION PrimerCaracter(@str nvarchar(300))
RETURNS int
EXTERNAL NAME SQLCLRDemo2.SQLFunctions.PrimerCaracter

SELECT dbo.PrimerCaracter('asdfadsfasdfaasdga')