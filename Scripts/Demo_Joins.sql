USE [master]
GO

CREATE DATABASE [Demo_Joins]
GO

USE [Demo_Joins]
GO

CREATE TABLE [dbo].[Conjunto_A]
(
	[conjunto_AID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
	[descripcion] [nvarchar](50) NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
)
GO

CREATE TABLE [dbo].[Conjunto_B](
	[conjunto_BID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[conjunto_AID] [int] NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
	[cantidad] [int] NOT NULL,
	[precio] [money] NOT NULL,
)
GO

SELECT * FROM Conjunto_A
SELECT * FROM Conjunto_B

SELECT * FROM Conjunto_A, Conjunto_B

SELECT * FROM Conjunto_A AS a INNER JOIN Conjunto_B AS b
ON a.conjunto_AID = b.conjunto_AID

SELECT * FROM Conjunto_A AS a, Conjunto_B AS b
WHERE a.conjunto_AID = b.conjunto_BID

SELECT * FROM Conjunto_A AS a INNER JOIN Conjunto_B AS b
ON a.nombre = b.nombre

SELECT * FROM Conjunto_A AS a LEFT JOIN Conjunto_B AS b
ON a.nombre = b.nombre 

SELECT * FROM Conjunto_A AS a RIGHT JOIN Conjunto_B AS b
ON a.nombre = b.nombre

SELECT * FROM Conjunto_A AS a LEFT JOIN Conjunto_B AS b
ON a.nombre = b.nombre
WHERE b.nombre IS NULL

---------------------Clase martes 2 de mayo de 2023-----------------------
SELECT * FROM Conjunto_A
WHERE conjunto_AID = 20
SELECT * FROM Conjunto_B
WHERE conjunto_AID = 20

ALTER TABLE dbo.Conjunto_B
ADD CONSTRAINT [FK_CB-CA] FOREIGN KEY (conjunto_AID)
REFERENCES dbo.Conjunto_A (conjunto_AID)

--eSTE QUERY ES LO MISMO QUE EL DE ARRIBA
ALTER TABLE dbo.Conjunto_B
ADD CONSTRAINT [FK_CB-CA] FOREIGN KEY (conjunto_AID)
REFERENCES dbo.Conjunto_A (conjunto_AID)
ON DELETE NO ACTION
ON UPDATE NO ACTION

SELECT * FROM Conjunto_A
WHERE conjunto_AID = 20
SELECT * FROM Conjunto_B
WHERE conjunto_AID = 20

ALTER TABLE Conjunto_B
NOCHECK CONSTRAINT [FK_CB-CA]

UPDATE Conjunto_A SET conjunto_AID = 10000
WHERE conjunto_AID = 20

SELECT * FROM Conjunto_A WHERE conjunto_AID IN (20, 10000)
SELECT * FROM Conjunto_B WHERE conjunto_AID IN (20, 10000)

DELETE Conjunto_A WHERE conjunto_AID = 10000

ALTER TABLE Conjunto_B
CHECK CONSTRAINT [FK_CB-CA]

ALTER TABLE dbo.Conjunto_B
DROP CONSTRAINT [FK_CB-CA]

--------------------------------------------------------------------
SELECT * FROM Conjunto_A
WHERE conjunto_AID = 22
SELECT * FROM Conjunto_B
WHERE conjunto_AID = 22

DELETE FROM Conjunto_B WHERE conjunto_AID = 20

ALTER TABLE dbo.Conjunto_B
ADD CONSTRAINT [FK_CB-CA] FOREIGN KEY (conjunto_AID)
REFERENCES dbo.Conjunto_A (conjunto_AID)
ON DELETE CASCADE
ON UPDATE CASCADE

UPDATE Conjunto_A SET conjunto_AID = 10000
WHERE conjunto_AID = 21

DELETE Conjunto_A WHERE conjunto_AID = 10000

UPDATE Conjunto_B SET conjunto_AID = 10000
WHERE conjunto_AID = 22

DELETE Conjunto_B WHERE conjunto_AID = 22

ALTER TABLE dbo.Conjunto_B
DROP CONSTRAINT [FK_CB-CA]
--------------------------------------------------------------
SELECT * FROM Conjunto_A
WHERE conjunto_AID = 23
SELECT * FROM Conjunto_B
WHERE conjunto_AID = 23

ALTER TABLE dbo.Conjunto_B
ADD CONSTRAINT [FK_CB-CA] FOREIGN KEY (conjunto_AID)
REFERENCES dbo.Conjunto_A (conjunto_AID)
ON DELETE SET NULL
ON UPDATE SET NULL

ALTER TABLE Conjunto_B ALTER COLUMN conjunto_AID int NULL

UPDATE Conjunto_A SET conjunto_AID = 10000
WHERE conjunto_AID = 23

SELECT * FROM Conjunto_A
WHERE conjunto_AID IN (10000, 24)
SELECT * FROM Conjunto_B
WHERE conjunto_AID IS NULL OR conjunto_AID = 24

DELETE Conjunto_A WHERE conjunto_AID = 24

DELETE Conjunto_B WHERE conjunto_AID IS NULL
DELETE Conjunto_A WHERE conjunto_AID = 10000

ALTER TABLE dbo.Conjunto_B
DROP CONSTRAINT [FK_CB-CA]

ALTER TABLE Conjunto_B
ALTER COLUMN conjunto_AID int NOT NULL

-------------------------------------------------------------
SELECT * FROM Conjunto_A
WHERE conjunto_AID = 10000
SELECT * FROM Conjunto_B
WHERE conjunto_AID = 10000

ALTER TABLE Conjunto_B
ADD CONSTRAINT [DEFAULT(conjunto_AID)]
DEFAULT 10000 FOR conjunto_AID

ALTER TABLE dbo.Conjunto_B
ADD CONSTRAINT [FK_CB-CA] FOREIGN KEY (conjunto_AID)
REFERENCES dbo.Conjunto_A (conjunto_AID)
ON DELETE SET DEFAULT
ON UPDATE SET DEFAULT

UPDATE Conjunto_A SET conjunto_AID = 10000
WHERE conjunto_AID = 25

DELETE Conjunto_A WHERE conjunto_AID = 26

ALTER TABLE Conjunto_B
ALTER COLUMN conjunto_AID int NOT NULL

SELECT * FROM Empleado
SELECT * FROM Empleado AS e1 INNER JOIN Empleado AS e2
ON e1.id = e2.idManager
SELECT * FROM Empleado AS e1 LEFT JOIN Empleado AS e2
ON e1.id = e2.idManager

--Cursores
--CTEs = Common Table Expressions

DECLARE @id int
DECLARE @nombre nvarchar(50)
DECLARE EmpData CURSOR FOR SELECT id, nombre FROM Empleado
OPEN EmpData
FETCH NEXT FROM EmpData INTO @id, @nombre
WHILE @@fetch_status = 0
BEGIN
	/*SELECT @id, @nombre
	PRINT 'ID del empleado: ' + CAST(@id AS nvarchar(10))
	+ ' - Nombre del empleado: ' + @nombre*/

	/*SELECT
	@nombre AS Manager, nombre, departamento
	FROM Empleado WHERE idManager = @id*/

	SET NOCOUNT ON
	PRINT 'Manager: ' + @nombre

	DECLARE @nombreSub nvarchar(50)
	DECLARE EmpDataSub CURSOR FOR SELECT nombre FROM Empleado WHERE idManager = @id
	OPEN EmpDataSub
	FETCH NEXT FROM EmpDataSub INTO @nombreSub

	IF @@fetch_status != 0
			PRINT '   No hey gente a su cargo'
	WHILE @@fetch_status = 0
	BEGIN
		PRINT '   ' + @nombreSub
		FETCH NEXT FROM EmpDataSub INTO @nombreSub
	END
	CLOSE EmpDataSub
	DEALLOCATE EmpDataSub
	SET NOCOUNT OFF

	FETCH NEXT FROM EmpData INTO @id, @nombre
END
CLOSE EmpData
DEALLOCATE EmpData

SET NOCOUNT ON
DECLARE @orderID nvarchar(50)
DECLARE @orderDate nvarchar(50)
DECLARE @customerName nvarchar(50)
DECLARE SalesHeader CURSOR FOR
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
	WHERE pp.BusinessEntityID = 6387
OPEN SalesHeader
	FETCH NEXT FROM SalesHeader
	INTO @orderID, @orderDate, @customerName

	IF @@fetch_status = 0
		PRINT 'Cliente: ' + @customerName

	WHILE @@fetch_status = 0
	BEGIN
		PRINT '   Número de pedido: ' + CAST(@orderID AS nvarchar(20))
		PRINT '   Fecha del pedido: ' + CAST(@orderDate AS nvarchar(20))

		DECLARE @productID int
		DECLARE @productNumber nvarchar(50)
		DECLARE @quantity smallint
		DECLARE SalesDetail CURSOR FOR
			SELECT
				pp.ProductNumber, pp.ProductID, ssod.OrderQty
			FROM
				Sales.SalesOrderDetail AS ssod
				INNER JOIN Production.Product AS pp
				ON ssod.ProductID = pp.ProductID
			WHERE
				SalesOrderID = @orderID
		OPEN SalesDetail
			FETCH NEXT FROM SalesDetail
			INTO @productNumber, @productID, @quantity

			WHILE @@fetch_status = 0
			BEGIN
				PRINT '      Producto: ' + @productNumber
				PRINT '      Cantidad vendida: ' + CAST(@quantity AS nvarchar(10))

				FETCH NEXT FROM SalesDetail
				INTO @productNumber, @productID, @quantity
			END
		CLOSE SalesDetail
		DEALLOCATE SalesDetail

		PRINT ''
		PRINT ''
		FETCH NEXT FROM SalesHeader
		INTO @orderID, @orderDate, @customerName
	END
CLOSE SalesHeader
DEALLOCATE SalesHeader
SET NOCOUNT OFF

SET NOCOUNT ON
DECLARE @orderID nvarchar(50)
DECLARE @orderDate nvarchar(50)
DECLARE @customerName nvarchar(50)
DECLARE SalesHeader CURSOR FOR
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
	WHERE pp.BusinessEntityID = 6387
OPEN SalesHeader
	FETCH NEXT FROM SalesHeader
	INTO @orderID, @orderDate, @customerName

	IF @@fetch_status = 0
		PRINT 'Cliente: ' + @customerName

	WHILE @@fetch_status = 0
	BEGIN
		PRINT '   Número de pedido: ' + CAST(@orderID AS nvarchar(20))
		PRINT '   Fecha del pedido: ' + CAST(@orderDate AS nvarchar(20))

		DECLARE @productCategoryID int
		DECLARE @productSubCategoryID int
		DECLARE @subCatQty int
		DECLARE ProductCategories CURSOR FOR
			SELECT
				ppc.ProductCategoryID,
				pps.ProductSubcategoryID,
				SUM(ssod.OrderQty) AS SubCategoryQty
			FROM
				Sales.SalesOrderDetail AS ssod
				INNER JOIN  Production.Product AS pp
					ON ssod.ProductID = pp.ProductID
				INNER JOIN Production.ProductSubcategory AS pps
					ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
				INNER JOIN Production.ProductCategory AS ppc
					ON pps.ProductCategoryID = ppc.ProductCategoryID
			WHERE
				ssod.SalesOrderID = @orderID
			GROUP BY ppc.ProductCategoryID, pps.ProductSubcategoryID
		OPEN ProductCategories
			FETCH NEXT FROM ProductCategories
			INTO @productCategoryID, @productSubCategoryID, @subCatQty

			IF @@fetch_status = 0
			BEGIN
				DECLARE @categoryName nvarchar(50) = (SELECT [Name] FROM Production.ProductCategory WHERE ProductCategoryID = @productCategoryID)
				DECLARE @categoryQty int = 
				(SELECT
					SUM(ssod.OrderQty) AS SubCategoryQty
				FROM
					Sales.SalesOrderDetail AS ssod
					INNER JOIN  Production.Product AS pp
						ON ssod.ProductID = pp.ProductID
					INNER JOIN Production.ProductSubcategory AS pps
						ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
					INNER JOIN Production.ProductCategory AS ppc
						ON pps.ProductCategoryID = ppc.ProductCategoryID
				WHERE
					ssod.SalesOrderID = @orderID AND
					ppc.ProductCategoryID = @productCategoryID
				GROUP BY ppc.ProductCategoryID)
				PRINT '      Categoría: ' + @categoryName + ' | Total vendido: ' + CAST(@categoryQty AS nvarchar(20))
			END

			WHILE @@fetch_status = 0
			BEGIN
				DECLARE @subCategoryName nvarchar(50) = (SELECT [Name] FROM Production.ProductSubcategory WHERE ProductSubcategoryID = @productSubCategoryID)
				PRINT '         Sub Categoría: ' + @subCategoryName + ' | Total vendido: ' + CAST(@subCatQty AS nvarchar(20))

				DECLARE @productID int
				DECLARE @productNumber nvarchar(50)
				DECLARE @quantity smallint
				DECLARE SalesDetail CURSOR FOR
					SELECT
						pp.ProductNumber, pp.ProductID, ssod.OrderQty
					FROM
						Sales.SalesOrderDetail AS ssod
						INNER JOIN Production.Product AS pp
						ON ssod.ProductID = pp.ProductID
					WHERE
						SalesOrderID = @orderID AND
						pp.ProductSubcategoryID = @productSubCategoryID
						
				OPEN SalesDetail
					FETCH NEXT FROM SalesDetail
					INTO @productNumber, @productID, @quantity

					WHILE @@fetch_status = 0
					BEGIN
						PRINT '            Producto: ' + @productNumber + ' - ' + CAST(@productID AS nvarchar(20)) +
						' | Cantidad vendida: ' + CAST(@quantity AS nvarchar(10))

						FETCH NEXT FROM SalesDetail
						INTO @productNumber, @productID, @quantity
					END
				CLOSE SalesDetail
				DEALLOCATE SalesDetail

				FETCH NEXT FROM ProductCategories
				INTO @productCategoryID, @productSubCategoryID, @subCatQty
			END
		CLOSE ProductCategories
		DEALLOCATE ProductCategories

		PRINT ''
		PRINT ''
		FETCH NEXT FROM SalesHeader
		INTO @orderID, @orderDate, @customerName
	END
CLOSE SalesHeader
DEALLOCATE SalesHeader
SET NOCOUNT OFF