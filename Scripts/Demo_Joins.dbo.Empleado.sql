USE [Demo_Joins]
GO
/****** Object:  Table [dbo].[Empleado]    Script Date: 03/05/2023 11:41:39 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleado](
	[id] [int] NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
	[departamento] [nvarchar](50) NOT NULL,
	[idManager] [int] NULL,
 CONSTRAINT [PK_Empleado] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Empleado] ([id], [nombre], [departamento], [idManager]) VALUES (1, N'Hugo', N'Ventas', NULL)
INSERT [dbo].[Empleado] ([id], [nombre], [departamento], [idManager]) VALUES (2, N'Paco', N'Ventas', 1)
INSERT [dbo].[Empleado] ([id], [nombre], [departamento], [idManager]) VALUES (3, N'Luis', N'Ventas', 1)
INSERT [dbo].[Empleado] ([id], [nombre], [departamento], [idManager]) VALUES (4, N'Juan', N'Ventas', 1)
INSERT [dbo].[Empleado] ([id], [nombre], [departamento], [idManager]) VALUES (5, N'Pedro', N'Ventas', 2)
INSERT [dbo].[Empleado] ([id], [nombre], [departamento], [idManager]) VALUES (6, N'Alejandro', N'Compras', 4)
INSERT [dbo].[Empleado] ([id], [nombre], [departamento], [idManager]) VALUES (7, N'Rodrigo', N'Compras', 6)
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_Empleado] FOREIGN KEY([idManager])
REFERENCES [dbo].[Empleado] ([id])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_Empleado]
GO
