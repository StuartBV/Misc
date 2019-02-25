CREATE TABLE [dbo].[Redemptions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[iCardsID] [int] NULL,
[CardID] [int] NULL,
[CashSettled] [bit] NULL,
[CardActivated] [tinyint] NULL,
[CardActivatedDate] [datetime] NULL CONSTRAINT [DF_Redemptions_CardActivatedDate] DEFAULT (NULL),
[CurrentCardValue] [money] NULL,
[LastTransactionLocation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastTransactionDate] [datetime] NULL CONSTRAINT [DF_Redemptions_LastTransactionDate] DEFAULT (NULL),
[AdditionalInfo] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardValueOnCompletion] [money] NULL,
[CardNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Redeemed] [tinyint] NULL CONSTRAINT [DF_Redemptions_Redeemed] DEFAULT ((0)),
[RedeemedDate] [datetime] NULL,
[CardBlockedonTsys] [bit] NULL,
[CardBlockedDate] [datetime] NULL CONSTRAINT [DF_Redemptions_CardBlockedDate] DEFAULT (NULL),
[CardCancelledonTsys] [tinyint] NULL,
[CardCancelledDate] [datetime] NULL CONSTRAINT [DF_Redemptions_CardCancelledDate] DEFAULT (NULL),
[SentToBank] [datetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL CONSTRAINT [DF_Redemptions_AlteredDate] DEFAULT (NULL),
[InvoiceBatchNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Redemptions] ADD CONSTRAINT [PK_Redemptions] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_cardid] ON [dbo].[Redemptions] ([CardID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_icardsid] ON [dbo].[Redemptions] ([iCardsID]) ON [PRIMARY]
GO
