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