CREATE TABLE [dbo].[syslookup]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Flags] [real] NULL,
[ExtraCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtraDesc] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_syslookup_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[syslookup] ADD CONSTRAINT [PK_syslookup] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
