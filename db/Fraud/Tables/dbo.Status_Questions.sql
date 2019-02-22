CREATE TABLE [dbo].[Status_Questions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sequence] [tinyint] NULL,
[answerid] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Status_Questions] ADD CONSTRAINT [PK_Status_Questions] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
