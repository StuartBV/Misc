CREATE TABLE [dbo].[LetterTypes]
(
[letterTypeId] [tinyint] NOT NULL,
[description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FooterType] [tinyint] NOT NULL CONSTRAINT [DF_LetterTypes_FooterType] DEFAULT ((0)),
[appendFooter] [bit] NOT NULL CONSTRAINT [DF_LetterTypes_appendFooter] DEFAULT ((1)),
[AutoGenerateFkId] [bit] NOT NULL CONSTRAINT [DF_LetterTypes_AutoGenerateFkId] DEFAULT ((0)),
[ShowContainer] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterTypes] ADD CONSTRAINT [PK_LetterTypes] PRIMARY KEY CLUSTERED  ([letterTypeId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Auto-Generate FKIDs for Letter Type, Default= No', 'SCHEMA', N'dbo', 'TABLE', N'LetterTypes', 'COLUMN', N'AutoGenerateFkId'
GO
