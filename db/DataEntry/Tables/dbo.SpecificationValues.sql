CREATE TABLE [dbo].[SpecificationValues]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[CmsId] [int] NOT NULL,
[Type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SpecificationValues] ADD CONSTRAINT [PK_dbo.SpecificationValues] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
