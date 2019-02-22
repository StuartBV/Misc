CREATE TABLE [dbo].[syslookup]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Flags] [real] NULL,
[ExtraCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtraDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[syslookup] ADD CONSTRAINT [PK_syslookup] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_code] ON [dbo].[syslookup] ([TableName], [Code]) ON [PRIMARY]
GO
