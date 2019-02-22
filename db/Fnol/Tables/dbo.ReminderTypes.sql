CREATE TABLE [dbo].[ReminderTypes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DaysUntilDue] [smallint] NULL CONSTRAINT [DF_ReminderTypes_DaysUntilDue] DEFAULT ((0)),
[Searchable] [bit] NULL CONSTRAINT [DF_ReminderTypes_Searchable] DEFAULT ((0)),
[ActionType] [bit] NULL CONSTRAINT [DF_ReminderTypes_ActionType] DEFAULT ((0)),
[PrimaryReminder] [bit] NULL CONSTRAINT [DF_ReminderTypes_PrimaryReminder] DEFAULT ((0)),
[CreateDate] [datetime] NOT NULL,
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReminderTypes] ADD CONSTRAINT [PK_ReminderTypes] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_type] ON [dbo].[ReminderTypes] ([Code], [ID], [PrimaryReminder], [ActionType], [Searchable]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_searchable] ON [dbo].[ReminderTypes] ([Searchable], [ID]) ON [PRIMARY]
GO
