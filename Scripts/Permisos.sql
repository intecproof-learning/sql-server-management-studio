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
