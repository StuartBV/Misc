CREATE TABLE [dbo].[LostStolenCards]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[iCardsID] [int] NULL,
[CardID] [int] NULL,
[Type] [int] NULL,
[Date] [datetime] NULL,
[CrimeRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastTranDate] [datetime] NULL,
[LastTranRetailer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TSYSID] [int] NULL CONSTRAINT [DF_LostStolenCards_TSYSID] DEFAULT ((0)),
[UsedAfterLastTran] [tinyint] NULL CONSTRAINT [DF_LostStolenCards_UsedAfterLastTran] DEFAULT ((0)),
[AdditionalInfo] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LostStolenCards] ADD CONSTRAINT [PK_LostStolenCards] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'1=Lost  2=Stolen  0=Error', 'SCHEMA', N'dbo', 'TABLE', N'LostStolenCards', 'COLUMN', N'Type'
GO
