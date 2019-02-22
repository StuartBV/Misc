CREATE TABLE [dbo].[FraudLog]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[FIN] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BookingID] [int] NULL,
[TransDate] [datetime] NULL,
[UserId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TierStage] [smallint] NULL,
[Status] [smallint] NULL,
[ActionTaken] [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FraudLog] ADD CONSTRAINT [PK_FraudLog] PRIMARY KEY CLUSTERED  ([LogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_ActionTaken] ON [dbo].[FraudLog] ([ActionTaken]) INCLUDE ([FIN], [TransDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_FIN] ON [dbo].[FraudLog] ([FIN]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_UserID] ON [dbo].[FraudLog] ([UserId], [ActionTaken]) INCLUDE ([FIN], [TransDate]) ON [PRIMARY]
GO
