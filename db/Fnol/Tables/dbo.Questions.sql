CREATE TABLE [dbo].[Questions]
(
[QuestionaireID] [int] NOT NULL,
[QuestionID] [int] NOT NULL IDENTITY(1, 1),
[Question] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seq] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Questions] ADD CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED  ([QuestionaireID], [QuestionID]) ON [PRIMARY]
GO
