CREATE TABLE [dbo].[History_Settlements]
(
[TransactionID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SettlementID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserAccountStatus] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HoldMatchAmount] [money] NULL,
[Postedamount] [money] NULL,
[SettlementDate] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceAmount] [money] NULL,
[ProcessedDate] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferenceNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MerchantCode] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Merchant] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MerchantID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MerchantCity] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MerchantCountry] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MerchantPostcode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TerminalID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SettlementType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OperationDate] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SettlementClass] [int] NULL,
[Settlement] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sourceCurrency] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DestinationCurrency] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Interchange] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Markup] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_History_Settlements_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[History_Settlements] ADD CONSTRAINT [PK_History_Settlements] PRIMARY KEY CLUSTERED  ([TransactionID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_UserID] ON [dbo].[History_Settlements] ([UserID]) ON [PRIMARY]
GO
