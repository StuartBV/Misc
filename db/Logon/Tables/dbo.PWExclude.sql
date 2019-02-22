CREATE TABLE [dbo].[PWExclude]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Password] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PWExclude] ADD CONSTRAINT [PK_PWExclude] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description for why excluded', 'SCHEMA', N'dbo', 'TABLE', N'PWExclude', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bad Password to be excluded', 'SCHEMA', N'dbo', 'TABLE', N'PWExclude', 'COLUMN', N'Password'
GO
