CREATE TABLE [dbo].[LetterFormats]
(
[letterFormatId] [tinyint] NOT NULL,
[description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterFormats] ADD CONSTRAINT [PK_LetterFormats] PRIMARY KEY CLUSTERED  ([letterFormatId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
