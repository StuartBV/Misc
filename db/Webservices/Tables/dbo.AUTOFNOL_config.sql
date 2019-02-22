CREATE TABLE [dbo].[AUTOFNOL_config]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InsCo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchemaUri] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchemaFile] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AUTOFNOL_config] ADD CONSTRAINT [PK_AutoFNOL_config] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
