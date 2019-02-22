CREATE TABLE [dbo].[WorkToList]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserId] [dbo].[UserID] NULL,
[ReminderType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkToList] ADD CONSTRAINT [PK_WorkToList] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_user] ON [dbo].[WorkToList] ([UserId], [ID]) ON [PRIMARY]
GO
