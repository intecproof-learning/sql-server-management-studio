/*
	Entities: Son los objetos (Persona) a los que se les
	asigana el permiso
	Securables: Son los objetos sobre los cuales se ejerce el
	permiso
	Permissions: Son las acciones que puede puede hacer
	el entity sobre el securable.
*/

--GRANT, WITH GRANT, DENY, REVOKE
USE [master]
GO
CREATE LOGIN Demologin WITH PASSWORD = 'Admin123'
GO

--Validar permisos
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Person', 'SCHEMA')
REVERT

USE [AdventureWorks]
GO
SELECT * FROM fn_my_permissions('Person', 'SCHEMA')
CREATE USER Demologin FROM LOGIN Demologin
GO

GRANT CONTROL ON SCHEMA::Person TO Demologin
GO
--Valido permisos asignados sobre el eschema Person
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Person', 'SCHEMA')
REVERT

EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production', 'SCHEMA')
REVERT

EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Person.Person', 'OBJECT')
REVERT

EXECUTE AS USER = 'Demologin'
SELECT * FROM Person.Person
REVERT

EXECUTE AS USER = 'Demologin'
SELECT * FROM Production.Product
REVERT

--Denegar permiso
DENY CONTROL ON SCHEMA::Production TO Demologin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production', 'SCHEMA')
REVERT

DENY CONTROL ON [Person].[Password] TO Demologin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('[Person].[Password]', 'OBJECT')
REVERT

GRANT SELECT ON Production.Product TO DemoLogin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production.Product', 'OBJECT')
REVERT

GRANT CONTROL ON SCHEMA::Production TO Demologin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production', 'SCHEMA')
REVERT

REVOKE CONTROL ON SCHEMA::Production TO Demologin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production', 'SCHEMA')
REVERT

--Ejercicio Guiado
--1.- DENY a todo el esquema Production
DENY CONTROL ON SCHEMA::Production TO Demologin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production', 'SCHEMA')
REVERT
--2.- REVOKE a la tabla Production.Product
REVOKE CONTROL ON Production.Product TO Demologin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production.Product', 'OBJECT')
REVERT
--3.- GRANT SELECT sobre la tabla Production.Product
GRANT SELECT ON Production.Product TO DemoLogin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production.Product', 'OBJECT')
REVERT

--Quita el grant o deny de todo el esquema Production
REVOKE CONTROL ON SCHEMA::Production TO Demologin
GO

--1.- GRANT SELECT sobre la tabla Production.Product
GRANT SELECT ON Production.Product TO DemoLogin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production.Product', 'OBJECT')
REVERT
--2.- REVOKE CONTROL sobre la tablla Production.Product
-- esta instucción no quita el permiso de select asignado en 
--el paso 1
REVOKE CONTROL ON Production.Product TO Demologin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production.Product', 'OBJECT')
REVERT

--3.- GRANT CONTROL sobre la tabla Production.Product
GRANT CONTROL ON Production.Product TO Demologin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production.Product', 'OBJECT')
REVERT

--Ejercicio Guiado
--1.- GRANT SELECT sobre la tabla Production.Document
GRANT SELECT ON Production.Document TO Demologin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production.Document', 'OBJECT')
REVERT
--2.- DENY SELECT sobre la tabla Production.Document
DENY SELECT ON Production.Document TO Demologin
GO
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions('Production.Document', 'OBJECT')
REVERT

--Pendiente
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions(NULL, 'OBJECT')
REVERT

------WITH GRANT
GRANT EXECUTE ON [dbo].[usp_GetProductVendors_LoadTest]
TO Demologin WITH GRANT OPTION
EXECUTE AS USER = 'Demologin'
SELECT * FROM fn_my_permissions
('[dbo].[usp_GetProductVendors_LoadTest]', 'OBJECT')
REVERT