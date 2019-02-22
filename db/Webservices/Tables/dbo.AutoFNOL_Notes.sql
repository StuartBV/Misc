CREATE TABLE [dbo].[AutoFNOL_Notes]
(
[NoteID] [int] NOT NULL IDENTITY(1, 1),
[MessageID] [int] NOT NULL,
[Name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NoteText] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_AutoFNOL_Notes_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutoFNOL_Notes] ADD CONSTRAINT [PK_AutoFNOL_Notes] PRIMARY KEY CLUSTERED  ([NoteID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_MessageID] ON [dbo].[AutoFNOL_Notes] ([MessageID]) ON [PRIMARY]
GO
