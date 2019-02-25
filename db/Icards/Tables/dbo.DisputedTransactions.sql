CREATE TABLE [dbo].[DisputedTransactions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[iCardsID] [int] NULL,
[CardID] [int] NULL,
[OnTSYS] [tinyint] NULL,
[TSYSID] [int] NULL CONSTRAINT [DF_DisputedTransactions_TSYSID] DEFAULT ((0)),
[TranDate] [datetime] NULL,
[TranRetailer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reason] [int] NULL,
[Possession] [tinyint] NULL,
[Access] [tinyint] NULL,
[AlsoAccess] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalInfo] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DisputedTransactions] ADD CONSTRAINT [PK_DisputedTransactions] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
