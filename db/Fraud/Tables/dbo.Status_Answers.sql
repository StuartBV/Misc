CREATE TABLE [dbo].[Status_Answers]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sequence] [tinyint] NULL,
[Questiontid] [int] NULL,
[isReminder] [tinyint] NULL CONSTRAINT [DF_StatusCodes_isReminder] DEFAULT ((0)),
[ReminderDays] [smallint] NULL CONSTRAINT [DF_StatusCodes_ReminderDays] DEFAULT ((0)),
[ActionRequired] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Status_Answers] ADD CONSTRAINT [PK_StatusCodes] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
