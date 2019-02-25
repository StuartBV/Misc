CREATE TABLE [dbo].[FISCardResponseLoad]
(
[RecId] [int] NOT NULL,
[Pan] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CardId] [bigint] NOT NULL,
[CardEvent] [int] NOT NULL,
[ExpiryDate] [smalldatetime] NOT NULL,
[StatCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Processed] [tinyint] NOT NULL CONSTRAINT [DF_FISCardResponseLoad_Processed] DEFAULT ((0)),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_FISCardResponseLoad_CreateDate] DEFAULT (getdate()),
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [idx_recid] ON [dbo].[FISCardResponseLoad] ([RecId]) ON [PRIMARY]
GO
