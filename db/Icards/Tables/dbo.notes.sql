CREATE TABLE [dbo].[notes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[iCardsID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Note] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Notes_CreatedBy] DEFAULT (getdate()),
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoteType] [tinyint] NULL CONSTRAINT [DF_Notes_NoteType] DEFAULT ((0)),
[NoteReason] [tinyint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[notes] ADD CONSTRAINT [PK_Notes] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_icardsid] ON [dbo].[notes] ([iCardsID]) ON [PRIMARY]
GO
