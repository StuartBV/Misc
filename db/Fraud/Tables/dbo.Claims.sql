CREATE TABLE [dbo].[Claims]
(
[ClaimID] [int] NOT NULL IDENTITY(1, 1),
[ClaimNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OriginClaimID] [int] NULL,
[QuoteCreatedDate] [datetime] NULL,
[QuoteCreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderCreatedDate] [datetime] NULL,
[OrderCreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderConfirmedDate] [datetime] NULL,
[OrderConfirmedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteSentDate] [datetime] NULL,
[QuoteSentMethod] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteFaxNum] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustID] [int] NULL,
[AccountRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceCoID] [int] NULL,
[LossADjusterID] [int] NULL,
[AllowedQty] [int] NULL,
[AllowedRRP] [smallmoney] NULL,
[AllowedDisc] [smallmoney] NULL,
[delegated] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[excess] [smallmoney] NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BrokerAdjuster] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAOffice] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginatingOffice] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Inspector] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InspectorRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InspectorEmail] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsurancePolicyNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceClaimNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LossAdjusterRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CauseofClaim] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateListReceived] [smalldatetime] NULL,
[FirstContactDate] [smalldatetime] NULL,
[ContactByPhone] [tinyint] NULL,
[AllowInitialLetter] [tinyint] NULL,
[AllowedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactLetterSent] [smalldatetime] NULL,
[Status] [smallint] NULL,
[CompletedDate] [smalldatetime] NULL,
[ExcessToCollect] [smallmoney] NULL,
[ExcessPaid] [smalldatetime] NULL,
[UpgradeValue] [smallmoney] NULL,
[UpgradePaid] [datetime] NULL,
[Pending] [tinyint] NULL,
[QuoteNote] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RRPVoucher] [tinyint] NULL,
[CancelCode] [smallint] NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimType] [smallint] NULL,
[CrimeRefNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IncidentDate] [smalldatetime] NULL,
[ClaimReceivedDate] [smalldatetime] NULL,
[CauseofClaimNotes] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SePScode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CancelDate] [datetime] NULL,
[InspectorPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SALimit] [smallmoney] NULL,
[HRLimit] [smallmoney] NULL,
[OtherLimit] [smallmoney] NULL,
[OfficeID] [int] NULL,
[Commercial] [tinyint] NULL,
[ListExclude] [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Claims] ADD CONSTRAINT [PK_Claims] PRIMARY KEY CLUSTERED  ([ClaimID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Channel] ON [dbo].[Claims] ([Channel]) INCLUDE ([ClaimID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_claimno] ON [dbo].[Claims] ([ClaimNo]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_custid] ON [dbo].[Claims] ([CustID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_originclaimid] ON [dbo].[Claims] ([OriginClaimID]) ON [PRIMARY]
GO
