CREATE TABLE Sales
(
	country nvarchar(50),
	region nvarchar(50),
	sales int
)

INSERT INTO Sales VALUES ('Canad�', 'Regi�n 1', 100)
INSERT INTO Sales VALUES ('Canad�', 'Regi�n 2', 200)
INSERT INTO Sales VALUES ('Canad�', 'Regi�n 2', 300)
INSERT INTO Sales VALUES ('Estados Unidos', 'Nuevo M�xico', 100)


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

--Paginaci�n
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
OFFSET 600 ROWS --Salata 600 filas, m�s de las que en la tabla (no marca error)
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


--CTE en subqueries
	SELECT
		ppc.ProductCategoryID,
		pps.ProductSubcategoryID,
		SUM(ssod.OrderQty) AS SubCategoryQty,
		ssod.SalesOrderID,
		(SELECT OrderDate FROM Sales.SalesOrderHeader WHERE SalesOrderID = ssod.SalesOrderID) AS OrderDate,
		(SELECT CONCAT(FirstName , ' ', LastName) FROM Person.Person WHERE BusinessEntityID = 6387) AS CustomerName
	FROM
		Sales.SalesOrderDetail AS ssod
		INNER JOIN  Production.Product AS pp
			ON ssod.ProductID = pp.ProductID
		INNER JOIN Production.ProductSubcategory AS pps
			ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
		INNER JOIN Production.ProductCategory AS ppc
			ON pps.ProductCategoryID = ppc.ProductCategoryID
	WHERE ssod.SalesOrderID IN (
			SELECT
				soh.SalesOrderID--,
				--soh.OrderDate,
				--CONCAT(pp.FirstName , ' ', pp.LastName) AS CustomerName
			FROM
				Sales.SalesOrderHeader AS soh
				INNER JOIN Sales.Customer AS sc
				ON soh.CustomerID = sc.CustomerID
				INNER JOIN Person.Person AS pp
				On sc.PersonID = pp.BusinessEntityID
			WHERE pp.BusinessEntityID = 6387
	)
	GROUP BY ppc.ProductCategoryID,
	pps.ProductSubcategoryID, ssod.SalesOrderID





	SELECT
		ppc.ProductCategoryID,
		pps.ProductSubcategoryID,
		SUM(ssod.OrderQty) AS SubCategoryQty,
		ssod.SalesOrderID,
		(SELECT OrderDate FROM Sales.SalesOrderHeader WHERE SalesOrderID = ssod.SalesOrderID) AS OrderDate,
		(SELECT CONCAT(FirstName , ' ', LastName) FROM Person.Person WHERE BusinessEntityID = 6387) AS CustomerName,
		(SELECT FirstName FROM Person.Person WHERE BusinessEntityID = 6387) AS FirstName,
		(SELECT LastName FROM Person.Person WHERE BusinessEntityID = 6387) AS LastName
	FROM
		Sales.SalesOrderDetail AS ssod
		INNER JOIN  Production.Product AS pp
			ON ssod.ProductID = pp.ProductID
		INNER JOIN Production.ProductSubcategory AS pps
			ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
		INNER JOIN Production.ProductCategory AS ppc
			ON pps.ProductCategoryID = ppc.ProductCategoryID
	WHERE EXISTS (
			SELECT
				soh.SalesOrderID
			FROM
				Sales.SalesOrderHeader AS soh
				INNER JOIN Sales.Customer AS sc
				ON soh.CustomerID = sc.CustomerID
				INNER JOIN Person.Person AS pp
				On sc.PersonID = pp.BusinessEntityID
			WHERE pp.BusinessEntityID = 6387
			AND soh.SalesOrderID = ssod.SalesOrderID
	)
	GROUP BY ppc.ProductCategoryID,
	pps.ProductSubcategoryID, ssod.SalesOrderID


--CTE con Subqueries final
	SELECT
	pc.SalesOrderID,
	pc.CustomerName,
	pc.OrderDate,
	(SELECT [Name] FROM Production.ProductCategory
	WHERE ProductCategoryID = pc.productCategoryID) AS PCName,
	(SELECT [Name] FROM Production.ProductSubcategory
	WHERE ProductSubcategoryID = pc.productSubcategoryID) AS PSCName,
	pc.SubCategoryQty,
	pp.ProductID,
	pp.ProductNumber,
	ssod.OrderQty
FROM
	Sales.SalesOrderDetail AS ssod
	INNER JOIN Production.Product AS pp
	ON ssod.ProductID = pp.ProductID
	--INNER JOIN ProductCategories_CTE AS pcc
	--ON pp.ProductSubcategoryID = pcc.productSubcategoryID AND
	--ssod.SalesOrderID = pcc.orderID
	INNER JOIN (
	SELECT
		ppc.ProductCategoryID,
		pps.ProductSubcategoryID,
		SUM(ssod.OrderQty) AS SubCategoryQty,
		ssod.SalesOrderID,
		(SELECT OrderDate FROM Sales.SalesOrderHeader WHERE SalesOrderID = ssod.SalesOrderID) AS OrderDate,
		(SELECT CONCAT(FirstName , ' ', LastName) FROM Person.Person WHERE BusinessEntityID = 6387) AS CustomerName
	FROM
		Sales.SalesOrderDetail AS ssod
		INNER JOIN  Production.Product AS pp
			ON ssod.ProductID = pp.ProductID
		INNER JOIN Production.ProductSubcategory AS pps
			ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
		INNER JOIN Production.ProductCategory AS ppc
			ON pps.ProductCategoryID = ppc.ProductCategoryID
	WHERE ssod.SalesOrderID IN (
			SELECT
				soh.SalesOrderID
			FROM
				Sales.SalesOrderHeader AS soh
				INNER JOIN Sales.Customer AS sc
				ON soh.CustomerID = sc.CustomerID
				INNER JOIN Person.Person AS pp
				On sc.PersonID = pp.BusinessEntityID
			WHERE pp.BusinessEntityID = 6387
	)
	GROUP BY ppc.ProductCategoryID,
	pps.ProductSubcategoryID, ssod.SalesOrderID
) AS pc
ON pp.ProductSubcategoryID = pc.productSubcategoryID AND ssod.SalesOrderID = pc.SalesOrderID

SELECT * FROM ufn_GetSalesByClientReport_V3(6387)

--Merge y tablas temporales
SELECT * FROM Production.Product

UPDATE Production.Product
SET ListPrice = 10
WHERE [Name] = 'Adjustable Race'

INSERT INTO Production.Product
(ColumnName1, ColumnName2, ..., ColumnName3)
VALUES(ValColumnName1, ValColumnName2, ..., ValColumnName3)

--Borra registros, ya sea mediante el filtrado (registros espec�ficos)
--O todos los registros eliminando 1 por 1
DELETE Production.Product
WHERE [Name] = 'Adjustable Race'

--Elimina todos los registros, omite el delete,
--es m�s r�pido que el delete
--Borra las p�ginas relacionadas con la tabla en cuesti�n
--Reinicia las columnas declaradas con identity
TRUNCATE TABLE Production.Product

GO
CREATE PROCEDURE dbo.InsertarUnitMeasure
@unitMeasureCode nchar(3),
@name nvarchar(25)
AS
BEGIN
	SET NOCOUNT ON;--ON se muestra en pantalla las filas manipuladas
	--OFF no se muestra en pantalla las filas manipuladas
	UPDATE Production.UnitMeasure SET [Name] = @name
	WHERE UnitMeasureCode = @unitMeasureCode

	IF (@@ROWCOUNT = 0)
	BEGIN
		INSERT INTO Production.UnitMeasure (UnitMeasureCode, [Name])
		VALUES (@unitMeasureCode, @name)
	END
END
GO

SELECT * FROM Production.UnitMeasure
EXEC InsertarUnitMeasure 'AAA', 'Test1'
EXEC InsertarUnitMeasure 'AAA', 'Test1-Update'

--Proceso MERGE
CREATE TABLE #TablaTemporal1
(
	ExistingCode nchar(3),
	ExistingName nvarchar(50),
	ExistingDate datetime,
	Accion nvarchar(20),
	NewCode nchar(3),
	[NewName] nvarchar(50),
	NewDate datetime
)
GO

SELECT * FROM #TablaTemporal1

CREATE TABLE ##TablaTemporal2
(
	ExistingCode nchar(3),
	ExistingName nvarchar(50),
	ExistingDate datetime,
	Accion nvarchar(20),
	NewCode nchar(3),
	[NewName] nvarchar(50),
	NewDate datetime
)
GO
SELECT * FROM ##TablaTemporal2

ALTER PROCEDURE dbo.InsertarUnitMeasure
@unitMeasureCode nchar(3),
@name nvarchar(25)
AS
BEGIN
	MERGE Production.UnitMeasure AS tgt
	USING (SELECT @unitMeasureCode, @name) AS
	src (UnitMeasureCode, [Name])
	ON (tgt.UnitMeasureCode = src.UnitMeasureCode)
	WHEN MATCHED THEN
		UPDATE SET [Name] = src.[Name]
	WHEN NOT MATCHED THEN
		INSERT (UnitMeasureCode, [Name])
		VALUES (src.UnitMEasureCode, src.[Name])
	OUTPUT deleted.*, $action, inserted.* INTO #TablaTemporal1;
END



EXEC InsertarUnitMeasure 'AAB', 'Test1' --insert
SELECT * FROM #TablaTemporal1
SELECT * FROM Production.UnitMeasure

EXEC InsertarUnitMeasure 'AAA', 'Test1-MERGE' -- UPDATE
SELECT * FROM #TablaTemporal1
SELECT * FROM Production.UnitMeasure

GO
CREATE PROCEDURE dbo.usp_ActualizarInventario
@orderDate datetime
AS
BEGIN
	MERGE Production.ProductInventory As tgt
	USING (
		SELECT ProductID, SUM(OrderQty)
		FROM Sales.SalesOrderHeader AS ssoh
		INNER JOIN Sales.SalesOrderDetail AS ssod
		ON ssoh.SalesOrderID = ssod.SalesOrderID
		AND ssoh.OrderDate = @orderDate
		GROUP BY ProductID
	) AS src(ProductID, OrderQty)
	ON (tgt.ProductID = src.ProductID)

	WHEN MATCHED AND tgt.Quantity - src.OrderQty <= 0
		THEN DELETE
	WHEN MATCHED
		THEN UPDATE SET tgt.Quantity = tgt.Quantity - src.OrderQty,
		tgt.ModifiedDate = GETDATE()
	OUTPUT $action, inserted.ProductID, inserted.Quantity,
	inserted.ModifiedDate, deleted.ProductID, deleted.Quantity,
	deleted.ModifiedDate;
END
GO

SELECT * FROM Production.ProductInventory

SELECT ProductID, SUM(OrderQty)
		FROM Sales.SalesOrderHeader AS ssoh
		INNER JOIN Sales.SalesOrderDetail AS ssod
		ON ssoh.SalesOrderID = ssod.SalesOrderID
		AND ssoh.OrderDate = '20110531'
		GROUP BY ProductID

SELECT * FROM Sales.SalesOrderHeader

EXEC dbo.usp_ActualizarInventario '20110531'
SELECT * FROM Production.ProductInventory
WHERE ProductID = 707

SELECT * FROM Sales.SalesReason

DECLARE @cambio TABLE (cambio nvarchar(20))
MERGE INTO Sales.SalesReason AS tgt
USING (VALUES ('Recomendaci�n', 'Other'),
('Review', 'Marketing'),
('Internet', 'Promotion')) AS src (NuevoNombre, NuevaRazon)
ON (tgt.[Name] = src.NuevoNombre)
WHEN MATCHED THEN
	UPDATE SET ReasonType = src.NuevaRazon
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Name], ReasonType) VALUES (NuevoNombre, NuevaRazon)
OUTPUT $action INTO @cambio;
SELECT * FROM @cambio

---------------------------INSERCT / EXCEPT

SELECT color FROM Production.Product
WHERE ProductID BETWEEN 500 AND 750
INTERSECT
SELECT color FROM Production.Product
WHERE ProductID BETWEEN 751 AND 1000

SELECT color FROM Production.Product
WHERE ProductID BETWEEN 500 AND 750
EXCEPT
SELECT color FROM Production.Product
WHERE ProductID BETWEEN 751 AND 1000

----------------------Window Queries
SELECT
object_id, [type], [type_desc]
FROM sys.objects
ORDER BY [type]

SELECT
--object_id, [type], [type_desc],
maximo = MAX(object_id),
minimo = MIN(object_id)
FROM sys.objects
ORDER BY [type]

SELECT
object_id, [type], [type_desc],
maximo = (SELECT MAX(object_id) FROM sys.objects WHERE [type] = so.[type]),
minimo = (SELECT MIN(object_id) FROM sys.objects WHERE [type] = so.[type])
FROM sys.objects AS so
ORDER BY [type]

SELECT
object_id, [type], [type_desc],
maximo = MAX(object_id) OVER (PARTITION BY [type]),
minimo = MIN(object_id) OVER (PARTITION BY [type])
FROM sys.objects AS so
ORDER BY [type]

SELECT
object_id, [type], [type_desc],
maximo = MAX(object_id) OVER (PARTITION BY [type] ORDER BY object_id),
minimo = MIN(object_id) OVER (PARTITION BY [type] ORDER BY object_id)
FROM sys.objects AS so

CREATE TABLE Resultados
(
	id int NOT NULL PRIMARY KEY,
	tipo nvarchar(50) NOT NULL,
	resultado int NOT NULL
)

INSERT INTO Resultados (id, tipo, resultado)
VALUES (1, 'Tipo 1', 2),
(2, 'Tipo 1', 2),
(3, 'Tipo 1', 2),
(4, 'Tipo 2', 2),
(5, 'Tipo 2', 2),
(6, 'Tipo 2', 2)

SELECT * FROM Resultados WHERE tipo = 'Tipo 1'

SELECT
id, tipo,
maximo = MAX(id) OVER (PARTITION BY tipo),
minimo = MIN(id) OVER (PARTITION BY tipo)
FROM Resultados

SELECT
id, tipo,
maximo = MAX(id) OVER (PARTITION BY tipo ORDER BY id),
minimo = MIN(id) OVER (PARTITION BY tipo ORDER BY id)
FROM Resultados

INSERT INTO Resultados (id, tipo, resultado)
VALUES (7, 'Tipo 1', 2),
(8, 'Tipo 1', 2),
(9, 'Tipo 2', 2),
(10, 'Tipo 2', 2),
(11, 'Tipo 3', 2),
(12, 'Tipo 3', 2),
(13, 'Tipo 3', 2),
(14, 'Tipo 3', 2),
(15, 'Tipo 3', 2),
(16, 'Tipo 4', 2),
(17, 'Tipo 4', 2),
(18, 'Tipo 4', 2),
(19, 'Tipo 4', 2),
(20, 'Tipo 4', 2),
(21, 'Tipo 5', 2),
(22, 'Tipo 5', 2),
(23, 'Tipo 5', 2),
(24, 'Tipo 5', 2),
(25, 'Tipo 5', 2)


SELECT id, tipo, resultado,
antes = SUM(resultado) OVER(ORDER BY tipo ROWS BETWEEN
					UNBOUNDED PRECEDING AND CURRENT ROW),
central = COUNT(*) OVER (ORDER BY tipo  ROWS BETWEEN 4 PRECEDING
						AND 2 FOLLOWING),
siguiente = COUNT(*) OVER (ORDER BY tipo ROWS BETWEEN CURRENT ROW
							AND UNBOUNDED FOLLOWING)
FROM Resultados ORDER BY tipo

SELECT * FROM Resultados
ORDER BY tipo

SELECT id, tipo FROM Resultados
ORDER BY id, tipo

SELECT id, tipo, resultado,
antes = SUM(resultado) OVER(PARTITION BY tipo ORDER BY tipo ROWS BETWEEN
					UNBOUNDED PRECEDING AND CURRENT ROW),
central = COUNT(*) OVER (PARTITION BY tipo  ORDER BY tipo ROWS BETWEEN 4 PRECEDING
						AND 2 FOLLOWING),
siguiente = COUNT(*) OVER (PARTITION BY tipo  ORDER BY tipo ROWS BETWEEN CURRENT ROW
							AND UNBOUNDED FOLLOWING)
FROM Resultados ORDER BY tipo

SELECT id, tipo, resultado
,ROW_NUMBER() OVER (ORDER BY id)--Me indica el n�mero de fila con base al ordenamiento
,RANK() OVER (ORDER BY resultado)
,DENSE_RANK() OVER (ORDER BY resultado)
,NTILE(4) OVER (ORDER BY resultado)
FROM Resultados