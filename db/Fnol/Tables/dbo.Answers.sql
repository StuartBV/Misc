CREATE TABLE [dbo].[Answers]
(
[QuestionID] [int] NOT NULL,
[AnswerID] [int] NOT NULL IDENTITY(1, 1),
[ClaimID] [int] NOT NULL,
[Answer] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Answers] ADD CONSTRAINT [PK_Answers] PRIMARY KEY CLUSTERED  ([AnswerID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_ClaimID] ON [dbo].[Answers] ([ClaimID]) ON [PRIMARY]
GO
