CREATE TABLE [dbo].[FNOL_Notes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClaimID] [int] NULL,
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Note] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoteType] [tinyint] NULL,
[NoteReason] [tinyint] NOT NULL,
[CreateDate] [smalldatetime] NULL,
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [smalldatetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FNOL_Notes] ADD CONSTRAINT [PK_FNOL_Notes] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_claimid] ON [dbo].[FNOL_Notes] ([ClaimID]) ON [PRIMARY]
GO
