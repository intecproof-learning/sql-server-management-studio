--1.- Mostrar a todos los empleados que se encuentran en el departamento de manufactura y de aseguramiento de la calidad.
SELECT e.BusinessEntityID, e.*,
d.[Name]
FROM HumanResources.Employee e 
INNER JOIN 
HumanResources.EmployeeDepartmentHistory h
ON e.BusinessEntityID = h.BusinessEntityID
INNER JOIN HumanResources.Department d
ON d.DepartmentID = h.DepartmentID
AND h.EndDate IS NULL
AND d.[Name] IN ('Quality Assurance', 'Production');

--2.- Indicar el listado de los empleados del sexo masculino y que sON solteros
SELECT * FROM HumanResources.Employee where Gender  = 'M' AND MaritalStatus = 'S';

--3.- Empleados cuyo apellido sea cON la letra “S”
SELECT * FROM HumanResources.Employee e 
INNER JOIN Person.PersON p 
ON e.BusinessEntityID = p.BusinessEntityID
AND p.LastName like 'S%';

--4.- Los empleados que sON del estado de Florida
SELECT pp.*,ps.[Name] FROM HumanResources.Employee he
INNER JOIN Person.PersON pp
ON pp.BusinessEntityID = he.BusinessEntityID
INNER JOIN Person.BusinessEntityAddress pb
ON pb.BusinessEntityID = pp.BusinessEntityID
INNER JOIN Person.[Address] pa
ON pa.AddressID = pb.AddressID
INNER JOIN Person.StateProvince ps
ON ps.StateProvinceID = pa.StateProvinceID
AND ps.[Name] = 'Florida';

--5.- La suma de las ventas hechas por cada empleado, y agrupadas por año
SELECT pp.FirstName, SUM(SalesQuota) AS total_vendido,
YEAR(QuotaDate) AS año
FROM Sales.SalesPersonQuotaHistory qh
INNER JOIN Person.PersON pp
ON qh.BusinessEntityID = pp.BusinessEntityID
GROUP BY pp.BusinessEntityID, YEAR(QuotaDate), pp.FirstName
ORDER BY  pp.BusinessEntityID;

--6.- El producto más vendido
SELECT top 1 pp.ProductID, pp.[Name], COUNT(ss.ProductID) AS veces_vendido
FROM Production.Product pp
INNER JOIN Sales.SalesOrderDetail ss
ON pp.ProductID = ss.ProductID
GROUP BY ss.ProductID, pp.[Name], pp.ProductID
ORDER BY  COUNT(ss.ProductID) desc;

--7.- El producto menos vendido
SELECT top 1 pp.ProductID, pp.[Name], COUNT(ss.ProductID) AS veces_vendido
FROM Production.Product pp
INNER JOIN Sales.SalesOrderDetail ss
ON pp.ProductID = ss.ProductID
GROUP BY ss.ProductID, pp.[Name], pp.ProductID
ORDER BY  COUNT(ss.ProductID) asc;

--8.- Listado de productos por número de ventas ordenando de mayor a menor
SELECT pp.ProductID, pp.[Name],pp.ProductNumber, pp.ListPrice,
COUNT(ss.ProductID) AS veces_vendido
FROM Production.Product pp
INNER JOIN Sales.SalesOrderDetail ss
ON pp.ProductID = ss.ProductID
GROUP BY ss.ProductID, pp.[Name], pp.ProductID,pp.ProductNumber, pp.ListPrice
ORDER BY  COUNT(ss.ProductID) desc;

--9.- Ventas por territorio
SELECT st.[Name], SUM(so.OrderQty * so.UnitPrice) AS total_vendido
FROM Sales.SalesOrderHeader sh
INNER JOIN Sales.SalesOrderDetail so
ON sh.SalesOrderID = so.SalesOrderID
INNER JOIN Sales.SalesTerritory st
ON st.TerritoryID = sh.TerritoryID
GROUP BY st.TerritoryID, st.[Name]
ORDER BY  SUM(so.OrderQty * so.UnitPrice) desc;

--10.- Crear un procedimiento almacenado que me permita consultar las ventas de un cliente específico por cualquier columna
--(idCliente, nombreColumna, valorColumna)

GO
ALTER PROCEDURE usp_GetSalesByClientandColumn
@idCliente int, @columnName nvarchar(50), @columnValue nvarchar(50)
AS
	DECLARE @query nvarchar(200) = CONCAT('SELECT * FROM ufn_GetSalesByClientReport(', @idCliente, ')', ' WHERE CONVERT(nvarchar(100), ', @columnName, ') = ''', @columnValue, '''')
	PRINT @query
	EXEC sp_executesql @query
GO

SELECT * FROM ufn_GetSalesByClientReport(6387)
EXEC usp_GetSalesByClientandColumn 6387, 'PCName', 'Accessories'