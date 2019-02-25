CREATE TABLE [dbo].[SysLookup]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Flags] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtraCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtraDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SysLookup] ADD CONSTRAINT [PK_SysLookup] PRIMARY KEY NONCLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [ixd_dtf_tablename_code] ON [dbo].[SysLookup] ([TableName], [Code]) ON [PRIMARY]
GO
