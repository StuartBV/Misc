CREATE TABLE [dbo].[Goldsmiths_Log]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClaimID] [int] NULL,
[Sender] [tinyint] NULL,
[SendStatus] [tinyint] NULL,
[MsgType] [tinyint] NULL,
[XML] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_GoldsmithsMessageLogs_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Goldsmiths_Log] ADD CONSTRAINT [PK_GoldsmithsMessageLogs] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
