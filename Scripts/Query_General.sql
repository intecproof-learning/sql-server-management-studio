CREATE TABLE Sales
(
	country nvarchar(50),
	region nvarchar(50),
	sales int
)

INSERT INTO Sales VALUES ('Canadá', 'Región 1', 100)
INSERT INTO Sales VALUES ('Canadá', 'Región 2', 200)
INSERT INTO Sales VALUES ('Canadá', 'Región 2', 300)
INSERT INTO Sales VALUES ('Estados Unidos', 'Nuevo México', 100)


--Groupo BY
SELECT country, region, SUM(sales) FROM Sales
GROUP BY country, region


--GROUP BY ROLLUP
SELECT country, region, SUM(sales) FROM Sales
GROUP BY ROLLUP(country, region)

--GROUP BY CUBE
SELECT country, region, SUM(sales) FROM Sales
GROUP BY CUBE(country, region)

--GROUP BY GROUPING SETS
SELECT country, region, SUM(sales) FROM Sales
GROUP BY GROUPING SETS(ROLLUP(country, region), CUBE(country, region))

SELECT country, region, SUM(sales) FROM Sales
GROUP BY ROLLUP(country, region)

SELECT country, region, SUM(sales) FROM Sales
GROUP BY CUBE(country, region)

SELECT country, region, SUM(sales) FROM Sales
GROUP BY ROLLUP(country, region)
UNION ALL
SELECT country, region, SUM(sales) FROM Sales
GROUP BY CUBE(country, region)

--Having
SELECT country, region, SUM(sales) AS Ventas FROM Sales
GROUP BY country, region
HAVING SUM(sales) > 400

--TOP
SELECT [Name], ListPrice FROM Production.Product
ORDER BY ListPrice DESC

SELECT TOP 20 [Name], ListPrice FROM Production.Product
ORDER BY ListPrice DESC

SELECT TOP 10 WITH TIES [Name], ListPrice FROM Production.Product
ORDER BY ListPrice DESC

SELECT TOP 101 PERCENT [Name], ListPrice FROM Production.Product
ORDER BY ListPrice DESC

--Paginación
SELECT [Name], ListPrice FROM Production.Product
ORDER BY ListPrice DESC
OFFSET 0 ROWS --No se salta ninguna fila
FETCH NEXT 10 ROWS ONLY --Obtienes las siguientes 10 filas

SELECT [Name], ListPrice FROM Production.Product
ORDER BY ListPrice DESC
OFFSET 100 ROWS --Salata 100 filas
FETCH NEXT 10 ROWS ONLY --Obtienes las siguientes 10 filas

SELECT [Name], ListPrice FROM Production.Product
ORDER BY ListPrice DESC --Order by es obligatorio
OFFSET 600 ROWS --Salata 600 filas, más de las que en la tabla (no marca error)
FETCH NEXT 10 ROWS ONLY --Obtienes las siguientes 10 filas

--DISTINCT
SELECT
sst.[Name],
sst.[Group]
FROM Sales.SalesTerritory AS sst
INNER JOIN Sales.SalesTerritoryHistory AS ssth
ON sst.TerritoryID = ssth.TerritoryID
ORDER BY sst.[Name]

SELECT DISTINCT
sst.[Name],
sst.[Group]
FROM Sales.SalesTerritory AS sst
INNER JOIN Sales.SalesTerritoryHistory AS ssth
ON sst.TerritoryID = ssth.TerritoryID
ORDER BY sst.[Name]


--Scalar Subqueries
SELECT MAX(SalesOrderID) AS MaxOrderID
FROM Sales.SalesOrderHeader

SELECT
SalesOrderID, ProductID, OrderQty
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = (SELECT MAX(SalesOrderID) FROM Sales.SalesOrderHeader)

SELECT
SalesOrderID, ProductID, OrderQty,
(SELECT AVG(OrderQTY) FROM Sales.SalesOrderDetail) AS AVGQty
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = (
SELECT MAX(SalesOrderID) FROM Sales.SalesOrderHeader
)

--Subqueries de multiple valor
SELECT
CustomerID, SalesOrderID
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (
	SELECT CustomerID FROM  Sales.Customer AS sc
	INNER JOIN Sales.SalesTerritory AS sst ON sc.TerritoryID = sst.TerritoryID
	WHERE sst.[Name] = 'Canada'
)

SELECT
sc.CustomerID, ssoh.SalesOrderID
FROM Sales.Customer AS sc INNER JOIN Sales.SalesOrderHeader AS ssoh
On sc.CustomerID = ssoh.CustomerID
INNER JOIN Sales.SalesTerritory AS sst ON sc.TerritoryID = sst.TerritoryID
where sst.[Name] = 'Canada'

SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT
CustomerID, SalesOrderID
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (
	SELECT CustomerID FROM  Sales.Customer AS sc
	INNER JOIN Sales.SalesTerritory AS sst ON sc.TerritoryID = sst.TerritoryID
	WHERE sst.[Name] = 'Canada'
)

SELECT
sc.CustomerID, ssoh.SalesOrderID
FROM Sales.Customer AS sc INNER JOIN Sales.SalesOrderHeader AS ssoh
On sc.CustomerID = ssoh.CustomerID
INNER JOIN Sales.SalesTerritory AS sst ON sc.TerritoryID = sst.TerritoryID
where sst.[Name] = 'Canada'

SELECT
CustomerID, SalesOrderID
FROM Sales.SalesOrderHeader AS A
WHERE EXISTS (
	SELECT CustomerID FROM  Sales.Customer AS sc
	INNER JOIN Sales.SalesTerritory AS sst ON sc.TerritoryID = sst.TerritoryID
	WHERE sst.[Name] = 'Canada' AND A.CustomerID = sc.CustomerID
)

SELECT
sc.CustomerID, ssoh.SalesOrderID
FROM Sales.SalesOrderHeader AS ssoh
INNER JOIN Sales.Customer AS sc ON ssoh.CustomerID = sc.CustomerID
INNER JOIN Sales.SalesTerritory AS sst ON sc.TerritoryID = sst.TerritoryID
WHERE sst.[Name] = 'Canada'
SET STATISTICS IO OFF
SET STATISTICS TIME OFF

--Subqueries corelacionados
SELECT SalesOrderID, CustomerID, OrderDate
FROM Sales.SalesOrderHeader AS ssoh
WHERE SalesOrderID =(
	SELECT MAX(SalesOrderID) FROM Sales.SalesOrderHeader AS ssoh_2
	WHERE ssoh_2.CustomerID = ssoh.CustomerID
	ORDER BY CustomerID, OrderDate
)

SELECT SalesOrderID, CustomerID, OrderDate
FROM Sales.SalesOrderHeader AS ssoh
WHERE SalesOrderID =(
	SELECT MAX(SalesOrderID) FROM Sales.SalesOrderHeader AS ssoh_2
	WHERE ssoh_2.CustomerID = ssoh.CustomerID
)
ORDER BY CustomerID, OrderDate

--EXISTS Y COUNT()
SELECT
sc.CustomerID, ss.[Name], sc.AccountNumber
FROM Sales.Customer AS sc INNER JOIN Sales.Store AS ss
ON sc.StoreID = ss.BusinessEntityID
WHERE (
	SELECT COUNT(*) FROM Sales.SalesOrderHeader AS ssoh
	WHERE ssoh.CustomerID = sc.CustomerID
) > 0

SELECT
sc.CustomerID, ss.[Name], sc.AccountNumber
FROM Sales.Customer AS sc INNER JOIN Sales.Store AS ss
ON sc.StoreID = ss.BusinessEntityID
WHERE (
	SELECT COUNT(*) FROM Sales.SalesOrderHeader AS ssoh
	WHERE ssoh.CustomerID = sc.CustomerID
) = 0

SELECT
sc.CustomerID, ss.[Name], sc.AccountNumber
FROM Sales.Customer AS sc INNER JOIN Sales.Store AS ss
ON sc.StoreID = ss.BusinessEntityID
WHERE EXISTS (
	SELECT * FROM Sales.SalesOrderHeader AS ssoh
	WHERE ssoh.CustomerID = sc.CustomerID
)

SELECT
sc.CustomerID, ss.[Name], sc.AccountNumber
FROM Sales.Customer AS sc INNER JOIN Sales.Store AS ss
ON sc.StoreID = ss.BusinessEntityID
WHERE NOT EXISTS (
	SELECT * FROM Sales.SalesOrderHeader AS ssoh
	WHERE ssoh.CustomerID = sc.CustomerID
)