ALTER FUNCTION [dbo].[ufn_GetSalesAllClientsReport](@skip int, @take int)
RETURNS TABLE
AS

RETURN
(
	WITH SalesHeader_CTE (orderID, orderDate, customerName)
	AS
	(
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
	),
	ProductCategories_CTE (productCategoryID, productSubcategoryID,
	SubCategoryQty, orderID)
	AS
	(
		SELECT
			ppc.ProductCategoryID,
			pps.ProductSubcategoryID,
			SUM(ssod.OrderQty) AS SubCategoryQty,
			shc.orderID
		FROM
			Sales.SalesOrderDetail AS ssod
			INNER JOIN  Production.Product AS pp
				ON ssod.ProductID = pp.ProductID
			INNER JOIN Production.ProductSubcategory AS pps
				ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
			INNER JOIN Production.ProductCategory AS ppc
				ON pps.ProductCategoryID = ppc.ProductCategoryID
			INNER JOIN SalesHeader_CTE AS shc
			ON ssod.SalesOrderID = shc.orderID
		GROUP BY ppc.ProductCategoryID,
		pps.ProductSubcategoryID, shc.orderID
	),
	SalesDetail_CTE (orderID,
	productCategoryID, productSubcategoryID, SubCategoryQty,
	productID, productNumber, quantity)
	AS
	(
		SELECT
			pcc.orderID,
			pcc.productCategoryID, pcc.productSubcategoryID, pcc.SubCategoryQty,
			pp.ProductNumber, pp.ProductID, ssod.OrderQty
		FROM
			Sales.SalesOrderDetail AS ssod
			INNER JOIN Production.Product AS pp
			ON ssod.ProductID = pp.ProductID
			INNER JOIN ProductCategories_CTE AS pcc
			ON pp.ProductSubcategoryID = pcc.productSubcategoryID AND
			ssod.SalesOrderID = pcc.orderID
	)
	
	SELECT
	shc.orderID,
	shc.customerName,
	shc.orderDate,
	(SELECT [Name] FROM Production.ProductCategory
	WHERE ProductCategoryID = sdc.productCategoryID) AS PCName,
	(SELECT [Name] FROM Production.ProductSubcategory
	WHERE ProductSubcategoryID = sdc.productSubcategoryID) AS PSCName,
	sdc.SubCategoryQty,
	sdc.productID,
	sdc.productNumber,
	sdc.quantity
	FROM
		SalesDetail_CTE AS sdc INNER JOIN SalesHeader_CTE AS shc
		ON sdc.orderID = shc.orderID
	ORDER BY shc.customerName DESC
	OFFSET @skip ROWS
	FETCH NEXT @take ROWS ONLY
)
GO

------------------Consulto la función paginada
SELECT * FROM ufn_GetSalesAllClientsReport(0, 100)

DECLARE @itemsPorPagina int = 10;
DECLARE @totalItems int =
(SELECT COUNT(*) FROM ufn_GetSalesAllClientsReport(0, 999999))
DECLARE @totalPaginas int = (@totalItems / @itemsPorPagina) + 1
PRINT @totalPaginas

GO
CREATE PROCEDURE usp_ObtenerPaginasGetSalesAllClientsReport_V2
@itemsPorPagina int,
@totalItems int OUT
AS
	SET @totalItems =
	(SELECT COUNT(*) FROM ufn_GetSalesAllClientsReport(0, 999999))
	DECLARE @totalPaginas int = (@totalItems / @itemsPorPagina) + 1

	--SELECT @totalPaginas AS TotalPaginas
GO

SELECT * FROM ufn_GetSalesAllClientsReport(0, 100)
EXEC usp_ObtenerPaginasGetSalesAllClientsReport 100



SELECT PCName, productID, SUM(quantity) FROM ufn_GetSalesAllClientsReport(0, 100)
GROUP BY ROLLUP(PCName, productID)