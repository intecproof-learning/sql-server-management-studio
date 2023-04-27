USE [master]
GO

CREATE DATABASE Demo_Indices
GO

USE [Demo_Indices]
GO

CREATE TABLE HeapTable
(
	heapTableID int IDENTITY(1,1) NOT NULL,
	productName nvarchar(50) NOT NULL,
	productNumber nvarchar(25) NOT NULL,
	carrierTrackingNumber nvarchar(25) NULL,
	orderQty smallint NOT NULL,
	unitPrice money NOT NULL,
	unitPriceDiscount money NOT NULL
)

CREATE TABLE ClusteredTable
(
	clusteredTableID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	productName nvarchar(50) NOT NULL,
	productNumber nvarchar(25) NOT NULL,
	carrierTrackingNumber nvarchar(25) NULL,
	orderQty smallint NOT NULL,
	unitPrice money NOT NULL,
	unitPriceDiscount money NOT NULL
)
GO

SELECT * FROM sys.indexes
WHERE OBJECT_NAME(object_id) = 'HeapTable'

SELECT * FROM sys.indexes
WHERE OBJECT_NAME(object_id) = 'ClusteredTable'

SELECT * FROM HeapTable
SELECT * FROM ClusteredTable

SET STATISTICS IO ON

INSERT INTO HeapTable
(productName, productNumber
, carrierTrackingNumber, orderQty,
unitPrice, unitPriceDiscount)
SELECT
p.[Name], p.ProductNumber
,sod.CarrierTrackingNumber, sod.OrderQty,
sod.UnitPrice, sod.UnitPriceDiscount
FROM AdventureWorks2019.Sales
.SalesOrderDetail AS sod
INNER JOIN AdventureWorks2019
.Production.Product AS p
ON sod.ProductID = p.ProductID

INSERT INTO ClusteredTable
(productName, productNumber
, carrierTrackingNumber, orderQty,
unitPrice, unitPriceDiscount)
SELECT
p.[Name], p.ProductNumber
,sod.CarrierTrackingNumber, sod.OrderQty,
sod.UnitPrice, sod.UnitPriceDiscount
FROM AdventureWorks2019.Sales
.SalesOrderDetail AS sod
INNER JOIN AdventureWorks2019
.Production.Product AS p
ON sod.ProductID = p.ProductID

SET STATISTICS IO OFF

SELECT
	[name] AS Index_Name,
	[type_desc] AS Index_Type,
	[is_unique],
	OBJECT_NAME(object_id) As Table_Name
FROM sys.indexes
WHERE object_id = OBJECT_ID('HeapTable')

SELECT
	[name] AS Index_Name,
	[type_desc] AS Index_Type,
	[is_unique],
	OBJECT_NAME(object_id) As Table_Name
FROM sys.indexes
WHERE object_id = OBJECT_ID('ClusteredTable')

SELECT
a.[name] AS Index_Name,
OBJECT_NAME(a.object_id) AS Table_Name,
COL_NAME(b.object_id, b.column_id) AS  Column_Name,
b.index_column_id,
b.key_ordinal,
b.is_included_column
FROM sys.indexes AS a INNER JOIN 
	sys.index_columns As b
ON
	a.object_id = b.object_id AND
	a.index_id = b.index_id
WHERE
	a.object_id = OBJECT_ID('HeapTable') OR
	a.object_id = OBJECT_ID('ClusteredTable')

EXEC sp_helpindex 'dbo.HeapTable'
GO
EXEC sp_helpindex 'dbo.ClusteredTable'
GO

SELECT * FROM HeapTable

SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT * FROM HeapTable WHERE productName LIKE '%moun%'
SELECT * FROM ClusteredTable WHERE productName LIKE '%moun%'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT * FROM HeapTable WHERE productNumber LIKE '%HL%'
SELECT * FROM ClusteredTable WHERE productNumber LIKE '%HL%'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT * FROM HeapTable
WHERE
	productName LIKE '%moun%' AND
	productNumber LIKE '%HL%'

SELECT * FROM ClusteredTable
WHERE
	productName LIKE '%moun%' AND
	productNumber LIKE '%HL%'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT * FROM HeapTable
WHERE productName = 'Mountain-100 Black, 42'

SELECT * FROM ClusteredTable
WHERE productName = 'Mountain-100 Black, 42'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT * FROM HeapTable
WHERE productNumber = 'BK-M82B-42'

SELECT * FROM ClusteredTable
WHERE productNumber = 'BK-M82B-42'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT * FROM HeapTable
WHERE
productName = 'Mountain-100 Black, 42'  AND
productNumber = 'BK-M82B-42'

SELECT * FROM ClusteredTable
WHERE
productName = 'Mountain-100 Black, 42' AND
productNumber = 'BK-M82B-42'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF


SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT * FROM HeapTable
WHERE heapTableID > 314598 AND  heapTableID < 972874

SELECT * FROM ClusteredTable
WHERE clusteredTableID > 314598 AND clusteredTableID < 972874

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT * FROM HeapTable
WHERE heapTableID = 314598

SELECT * FROM ClusteredTable
WHERE clusteredTableID = 314598

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT * FROM HeapTable
WHERE heapTableID = 314598 OR heapTableID = 972874

SELECT * FROM ClusteredTable
WHERE clusteredTableID = 314598 OR clusteredTableID = 972874

SET STATISTICS TIME OFF
SET STATISTICS IO OFF