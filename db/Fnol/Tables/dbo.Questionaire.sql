CREATE TABLE [dbo].[Questionaire]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Questionaire] ADD CONSTRAINT [PK_Questionaire] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
