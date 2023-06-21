CREATE PROCEDURE dbo.usp_GetSalesByClientReport_LoadTest
(@personID int)
AS
	;WITH SalesHeader_CTE (orderID, orderDate, customerName)
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
		WHERE
		pp.BusinessEntityID = @personID
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
	shc.orderID, shc.customerName, shc.orderDate,
	(SELECT [Name] FROM Production.ProductCategory
	WHERE ProductCategoryID = sdc.productCategoryID),
	(SELECT [Name] FROM Production.ProductSubcategory
	WHERE ProductSubcategoryID = sdc.productSubcategoryID),
	sdc.SubCategoryQty,
	sdc.productID, sdc.productNumber, sdc.quantity
	FROM
		SalesDetail_CTE AS sdc INNER JOIN SalesHeader_CTE AS shc
		ON sdc.orderID = shc.orderID
GO

SELECT
pp.ProductID, pp.[Name], pp.ProductNumber,
pp.Color, ppv.BusinessEntityID, pv.[Name],
ppv.StandardPrice
FROM
Production.Product AS pp INNER JOIN Purchasing.ProductVendor AS ppv
ON pp.ProductID = ppv.ProductID
INNER JOIN Purchasing.Vendor AS pv
ON ppv.BusinessEntityID = pv.BusinessEntityID