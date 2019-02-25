CREATE TABLE [dbo].[FISCardErrorsLoad]
(
[RecId] [int] NOT NULL,
[Action] [int] NOT NULL,
[Message] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Processed] [tinyint] NOT NULL CONSTRAINT [DF_FISCardErrorsLoad_Processed] DEFAULT ((0)),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_FISCardErrorsLoad_CreateDate] DEFAULT (getdate()),
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_processed] ON [dbo].[FISCardErrorsLoad] ([Processed]) ON [PRIMARY]
GO
