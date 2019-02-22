CREATE TABLE [dbo].[syslookup]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Category] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [int] NULL,
[MessageType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FaultCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FaultDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[syslookup] ADD CONSTRAINT [PK_syslookup] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
