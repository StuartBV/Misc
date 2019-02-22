CREATE TABLE [dbo].[ValuationBases]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[CmsBasis] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ValuationBases] ADD CONSTRAINT [PK_dbo.ValuationBases] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
