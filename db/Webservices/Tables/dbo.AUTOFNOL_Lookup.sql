CREATE TABLE [dbo].[AUTOFNOL_Lookup]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InsCo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InscoCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CMSCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AUTOFNOL_Lookup] ADD CONSTRAINT [PK_AutoFNOL_Lookup] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
