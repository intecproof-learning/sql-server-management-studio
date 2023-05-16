SELECT
*
FROM ufn_GetSalesByClientReport(6387) AS fn INNER JOIN
Sales.SalesOrderHeader AS ssoh
ON fn.orderID = ssoh.SalesOrderID

SELECT
*
FROM ufn_GetSalesByClientReport(SELECT BusinessEntityID FROM Person.Person)

SELECT * FROM Person.Person


USE Demo_Joins
GO

CREATE TABLE Autor
(
	id int PRIMARY KEY,
	nombre nvarchar(50) NOT NULL
)

CREATE TABLE Libro
(
	id int PRIMARY KEY,
	nombre nvarchar(50) NOT NULL,
	precio int NOT NULL,
	idAutor int NOT NULL
)

INSERT INTO Autor VALUES
(1, 'Hugo'),
(2, 'Paco'),
(3, 'Luis'),
(4, 'Pedro'),
(5, 'Juan'),
(6, 'Rodrigo'),
(7, 'Alejandro')

INSERT INTO Libro VALUES
(1, 'Libro 1', 500, 1),
(2, 'Libro 2', 600, 2),
(3, 'Libro 3', 700, 1),
(4, 'Libro 4', 800, 3),
(5, 'Libro 5', 900, 5),
(6, 'Libro 6', 400, 13)

--Join
SELECT * FROM Author AS a INNER JOIN Libro AS l
ON a.id = l.idAutor

SELECT * FROM Author AS a LEFT JOIN Libro AS l
ON a.id = l.idAutor

--crear función
GO
CREATE FUNCTION ufn_ObtenerLibrosPorIDAutor(@idAutor int)
RETURNS TABLE
AS
RETURN
(
	SELECT * FROM Libro WHERE idAutor = @idAutor
)
GO

SELECT * FROM ufn_ObtenerLibrosPorIDAutor(3)

SELECT * FROM Autor AS a, ufn_ObtenerLibrosPorIDAutor(a.id) AS b

SELECT * FROM Autor AS a INNER JOIN ufn_ObtenerLibrosPorIDAutor(a.id) AS b
ON a.id = b.idAutor

--CROSS APPLY
SELECT * FROM Autor
SELECT * FROM Autor AS a CROSS APPLY ufn_ObtenerLibrosPorIDAutor(a.id) AS b
SELECT * FROM Author AS a INNER JOIN Libro AS l
ON a.id = l.idAutor


--OUTER APPLY
SELECT * FROM Autor
SELECT * FROM Autor AS a OUTER APPLY ufn_ObtenerLibrosPorIDAutor(a.id) AS b
SELECT * FROM Author AS a LEFT JOIN Libro AS l
ON a.id = l.idAutor