CREATE TABLE [dbo].[Table_1](
	[id] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	[data] [nvarchar](1000) ,
	[dataNumber] [bigint] NOT NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[Table_2](
	[id] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
	[data] [nvarchar](1000) NOT NULL,
	[dataNumber] [bigint] NOT NULL
) ON [NEWFG]
GO

DECLARE @counter INT = 0;
WHILE @counter < 1000000
BEGIN
	INSERT INTO Table_1 ([data], dataNumber)
	SELECT REPLICATE('A', 1000),
	(ABS(CHECKSUM(NEWID())) % 1000000 + 1)

	INSERT INTO Table_2 ([data], dataNumber)
	SELECT REPLICATE('A', 1000),
	(ABS(CHECKSUM(NEWID())) % 1000000 + 1)

	SET @counter = @counter + 1
END


INSERT INTO Table_1 ([data], dataNumber)
SELECT REPLICATE('A', 1000), (ABS(CHECKSUM(NEWID())) % 1000000 + 1)
GO 1000000