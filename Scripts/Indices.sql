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