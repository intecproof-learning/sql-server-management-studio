---Query con OR
CREATE PROCEDURE usp_Abraham
AS
DECLARE @personID int = 6387
SELECT
	soh.SalesOrderID,
	soh.OrderDate,
	CONCAT(pp.FirstName , ' ', pp.LastName) AS CustomerName
FROM
	Sales.SalesOrderHeader AS soh
	INNER JOIN Sales.Customer AS sc
	ON soh.CustomerID = sc.CustomerID
	INNER JOIN Person.Person AS pp
	On sc.PersonID = pp.BusinessEntityID
WHERE
pp.BusinessEntityID = @personID OR
1 = CASE WHEN @personID IS NULL THEN 1 ELSE 0 END
GO


--Query de Leo
CREATE PROCEDURE usp_Leo
AS
declare @inicio int =  6387 
declare @fin int =  6387 

SELECT
		soh.SalesOrderID,
		soh.OrderDate,
		CONCAT(pp.FirstName , ' ', pp.LastName) AS CustomerName
	FROM
		Sales.SalesOrderHeader AS soh
		INNER JOIN Sales.Customer AS sc
		ON soh.CustomerID = sc.CustomerID
		INNER JOIN Person.Person AS pp
		On sc.PersonID = pp.BusinessEntityID
      WHERE pp.BusinessEntityID between @inicio and  @fin
GO

--Query de Isabel
CREATE PROCEDURE usp_Isa
AS
DECLARE @tipo int = 1
DECLARE @idCliente int = 6387

SELECT
			soh.SalesOrderID,
			soh.OrderDate,
			CONCAT(pp.FirstName , ' ', pp.LastName) AS CustomerName
		FROM
			Sales.SalesOrderHeader AS soh
			INNER JOIN Sales.Customer AS sc
			ON soh.CustomerID = sc.CustomerID
			INNER JOIN Person.Person AS pp
			On sc.PersonID = pp.BusinessEntityID
		WHERE (pp.BusinessEntityID = @idCliente AND @tipo=1) OR
		     (pp.BusinessEntityID > 0 AND @tipo=2)

GO


--Jorge
CREATE PROCEDURE usp_Jorge
AS
DECLARE @idCliente int = 6387
SELECT 
soh.SalesOrderID,
soh.OrderDate,
CONCAT(pp.FirstName , ' ', pp.LastName) AS CustomerName
FROM
Sales.SalesOrderHeader AS soh
INNER JOIN Sales.Customer AS sc
ON soh.CustomerID = sc.CustomerID
INNER JOIN Person.Person AS pp
On sc.PersonID = pp.BusinessEntityID
WHERE pp.BusinessEntityID = @idCliente
union 
SELECT 
soh.SalesOrderID,
soh.OrderDate,
CONCAT(pp.FirstName , ' ', pp.LastName) AS CustomerName
FROM
Sales.SalesOrderHeader AS soh
INNER JOIN Sales.Customer AS sc
ON soh.CustomerID = sc.CustomerID
INNER JOIN Person.Person AS pp
On sc.PersonID = pp.BusinessEntityID
WHERE  0 = @idCliente
GO


SET STATISTICS IO ON
SET STATISTICS TIME ON
EXEC usp_Jorge
EXEC usp_Isa
EXEC usp_Leo
EXEC usp_Abraham
SET STATISTICS IO OFF
SET STATISTICS TIME OFF