CREATE TABLE [dbo].[Log]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[iCardsId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Log_CreateDate] DEFAULT (getdate()),
[UserID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SupervisorID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data] [int] NULL,
[Text] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [smallint] NULL,
[WizardStage] [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Log] ADD CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_icardsid] ON [dbo].[Log] ([iCardsId]) ON [PRIMARY]
GO
