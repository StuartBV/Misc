CREATE TABLE [dbo].[FileExportLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Filename] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileSequence] [tinyint] NULL,
[DateSent] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FileExportLog] ADD CONSTRAINT [PK_FileExportLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
