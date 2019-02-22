CREATE TABLE [dbo].[AUTOFNOL_Claims]
(
[MessageID] [int] NOT NULL IDENTITY(1, 1),
[MessageLogID] [int] NULL,
[CustID] [int] NULL,
[AccountRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceCoID] [int] NULL,
[LossADjusterID] [int] NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BrokerAdjuster] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAOffice] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginatingOffice] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsurancePolicyNo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsurancePolicyLimit] [decimal] (19, 4) NULL,
[InsuranceClaimNo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PolicyInceptionDate] [smalldatetime] NULL,
[LossAdjusterRef] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CauseofClaim] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateListReceived] [smalldatetime] NULL,
[IncidentDate] [smalldatetime] NULL,
[ClaimReceivedDate] [smalldatetime] NULL,
[CauseofClaimNotes] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OfficeID] [int] NULL,
[AdditionalCustomerTitle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalCustomerFname] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalCustomerLname] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Claimtype] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Excess] [decimal] (18, 0) NULL CONSTRAINT [DF_AUTOFNOL_Claims_Excess] DEFAULT ((0)),
[ADCover] [decimal] (18, 0) NULL,
[SpecialInstructions] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SFindicator] [int] NULL CONSTRAINT [DF_AUTOFNOL_Claims_SFindicator] DEFAULT ((0)),
[ClaimOwner] [int] NULL,
[OtherLimit] [decimal] (18, 0) NULL CONSTRAINT [DF_AUTOFNOL_Claims_OtherLimit] DEFAULT ((0)),
[SALimit] [decimal] (18, 0) NULL CONSTRAINT [DF_AUTOFNOL_Claims_SALimit] DEFAULT ((0)),
[HRLimit] [decimal] (18, 0) NULL CONSTRAINT [DF_AUTOFNOL_Claims_HRLimit] DEFAULT ((0)),
[EmergencyClaim] [bit] NOT NULL CONSTRAINT [DF_AUTOFNOL_Claims_EmergencyClaim] DEFAULT ((0)),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_AUTOFNOL_Claims_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_AUTOFNOL_Claims_CreatedBy] DEFAULT ('sys')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AUTOFNOL_Claims] ADD CONSTRAINT [PK_AUTOFNOL_Claims] PRIMARY KEY CLUSTERED  ([MessageID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_custid] ON [dbo].[AUTOFNOL_Claims] ([CustID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MessageLogID] ON [dbo].[AUTOFNOL_Claims] ([MessageLogID], [CustID]) ON [PRIMARY]
GO
