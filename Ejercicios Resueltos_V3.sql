--Ejercicio 1
SELECT
ROW_NUMBER() OVER (PARTITION BY pa.PostalCode
ORDER BY ssp.SalesYTD DESC) AS NumeroFila,
CONCAT(pp.FirstName, pp.LastName) AS FullName,
ssp.SalesYTD,
pa.PostalCode
FROM Sales.SalesPerson AS ssp
INNER JOIN Person.Person AS pp
ON ssp.BusinessEntityID = pp.BusinessEntityID
INNER JOIN Person.[Address] AS pa
ON pp.BusinessEntityID = pa.AddressID

SELECT
SUM(1) OVER (PARTITION BY pa.PostalCode
ORDER BY pa.PostalCode ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW) AS NumeroFila,
CONCAT(pp.FirstName, pp.LastName) AS FullName,
ssp.SalesYTD,
pa.PostalCode
FROM Sales.SalesPerson AS ssp
INNER JOIN Person.Person AS pp
ON ssp.BusinessEntityID = pp.BusinessEntityID
INNER JOIN Person.[Address] AS pa
ON pp.BusinessEntityID = pa.AddressID

SELECT
COUNT(*) OVER (PARTITION BY pa.PostalCode
ORDER BY pa.PostalCode ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW) AS NumeroFila,
CONCAT(pp.FirstName, pp.LastName) AS FullName,
ssp.SalesYTD,
pa.PostalCode
FROM Sales.SalesPerson AS ssp
INNER JOIN Person.Person AS pp
ON ssp.BusinessEntityID = pp.BusinessEntityID
INNER JOIN Person.[Address] AS pa
ON pp.BusinessEntityID = pa.AddressID

--Ejercicio 2
SELECT
ROW_NUMBER() OVER (ORDER BY ssp.SalesYTD DESC) AS NumeroFila,
CONCAT(pp.FirstName, pp.LastName) AS FullName,
ssp.SalesYTD,
pa.PostalCode
FROM Sales.SalesPerson AS ssp
INNER JOIN Person.Person AS pp
ON ssp.BusinessEntityID = pp.BusinessEntityID
INNER JOIN Person.[Address] AS pa
ON pp.BusinessEntityID = pa.AddressID

SELECT
SUM(1) OVER (ORDER BY pa.PostalCode ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW) AS NumeroFila,
CONCAT(pp.FirstName, pp.LastName) AS FullName,
ssp.SalesYTD,
pa.PostalCode
FROM Sales.SalesPerson AS ssp
INNER JOIN Person.Person AS pp
ON ssp.BusinessEntityID = pp.BusinessEntityID
INNER JOIN Person.[Address] AS pa
ON pp.BusinessEntityID = pa.AddressID

SELECT
COUNT(*) OVER (ORDER BY pa.PostalCode ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW) AS NumeroFila,
CONCAT(pp.FirstName, pp.LastName) AS FullName,
ssp.SalesYTD,
pa.PostalCode
FROM Sales.SalesPerson AS ssp
INNER JOIN Person.Person AS pp
ON ssp.BusinessEntityID = pp.BusinessEntityID
INNER JOIN Person.[Address] AS pa
ON pp.BusinessEntityID = pa.AddressID

--Ejercicio 3
SELECT
CONCAT(pp.FirstName, pp.LastName) AS FullName,

ssp.SalesYTD,

SalesYTDAcumulado = SUM(ssp.SalesYTD) OVER
(PARTITION BY YEAR(ssp.ModifiedDate) ORDER BY YEAR(ssp.ModifiedDate)
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),

ssp.SalesLastYear,

Comparativa =CONCAT((SUM(ssp.SalesYTD) OVER
(PARTITION BY YEAR(ssp.ModifiedDate) ORDER BY YEAR(ssp.ModifiedDate)
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) * 100 / (
CASE WHEN SUM(ssp.SalesLastYear) OVER (PARTITION BY YEAR(ssp.ModifiedDate)) = 0 THEN 1 ELSE 
SUM(ssp.SalesLastYear) OVER (PARTITION BY YEAR(ssp.ModifiedDate)) END), '%'),

YEAR(ssp.ModifiedDate) AS SalesYear, 

DATEPART(YY, ssp.ModifiedDate) AS SalesYear_2
FROM Sales.SalesPerson AS ssp
INNER JOIN Person.Person AS pp
ON ssp.BusinessEntityID = pp.BusinessEntityID



