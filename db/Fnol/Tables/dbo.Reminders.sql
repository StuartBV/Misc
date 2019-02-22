CREATE TABLE [dbo].[Reminders]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DueDate] [datetime] NULL,
[Claimid] [int] NULL,
[Note] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastActioned] [datetime] NULL,
[DateCompleted] [datetime] NULL,
[CreateDate] [datetime] NOT NULL,
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reminders] ADD CONSTRAINT [PK_Reminders] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_user] ON [dbo].[Reminders] ([UserId], [Type], [DueDate], [LastActioned]) ON [PRIMARY]
GO
