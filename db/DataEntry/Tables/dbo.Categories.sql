CREATE TABLE [dbo].[Categories]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Spec] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Channel] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CmsId] [int] NOT NULL,
[Enabled] [bit] NOT NULL,
[ParentId] [int] NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categories] ADD CONSTRAINT [PK_dbo.Categories] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
