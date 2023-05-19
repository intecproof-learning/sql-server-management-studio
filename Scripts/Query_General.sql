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