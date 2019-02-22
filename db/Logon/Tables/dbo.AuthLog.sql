CREATE TABLE [dbo].[AuthLog]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[userid] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[password] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IP] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimID] [bigint] NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desc] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[appid] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_AuthLog_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtraCode] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuthLog] ADD CONSTRAINT [PK_AuthLog] PRIMARY KEY NONCLUSTERED  ([LogID]) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [Idx_CreateDate] ON [dbo].[AuthLog] ([CreateDate], [LogID]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO
