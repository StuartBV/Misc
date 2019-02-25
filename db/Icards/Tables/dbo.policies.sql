CREATE TABLE [dbo].[policies]
(
[ICardsID] [int] NOT NULL IDENTITY(100500, 1),
[CompanyID] [int] NULL,
[CustomerID] [int] NULL,
[Status] [int] NULL CONSTRAINT [DF_policies_Status] DEFAULT ((0)),
[SePSCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceCoID] [int] NULL,
[InsuranceClaimNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsurancePolicyNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrigOffice] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LossAdjuster] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LARef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAOffice] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IValRef] [int] NULL,
[IncidentDate] [smalldatetime] NULL,
[wizardstage] [tinyint] NULL,
[CancelReason] [tinyint] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_policies_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NULL CONSTRAINT [DF_policies_CreatedBy] DEFAULT ('sys'),
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[policies] ADD CONSTRAINT [PK_policies] PRIMARY KEY CLUSTERED  ([ICardsID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_CompanyID] ON [dbo].[policies] ([CompanyID]) INCLUDE ([ICardsID], [InsuranceClaimNo], [InsurancePolicyNo], [IValRef], [wizardstage]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_CustId] ON [dbo].[policies] ([CustomerID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_InsClaimNo] ON [dbo].[policies] ([InsuranceClaimNo]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_InsPolicy] ON [dbo].[policies] ([InsurancePolicyNo]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_ival] ON [dbo].[policies] ([IValRef]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_status] ON [dbo].[policies] ([Status]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Wizardstage] ON [dbo].[policies] ([wizardstage]) INCLUDE ([CancelReason], [CompanyID], [CreateDate], [ICardsID], [IValRef]) ON [PRIMARY]
GO
