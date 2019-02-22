CREATE TABLE [dbo].[FNOL_ClaimItems]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClaimID] [int] NOT NULL,
[AssetNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MakeModel] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemValue] [money] NULL,
[Age] [smallint] NULL,
[Category1] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category2] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupType] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Substantiation] [int] NULL,
[ValidationType] [int] NULL,
[Outcome] [int] NULL,
[SettlementType] [int] NULL,
[ProposedSettlement] [money] NULL CONSTRAINT [DF_FNOL_ClaimItems_ProposedSettlement] DEFAULT ((0.00)),
[Deduction] [tinyint] NULL CONSTRAINT [DF__FNOL_Clai__Deduc__6CA31EA0] DEFAULT ((0)),
[ExcessTaken] [bit] NULL CONSTRAINT [DF_FNOL_ClaimItems_ExcessTaken] DEFAULT ((0)),
[FinalSettlement] AS ([dbo].[FinalSettlement]([ID])),
[CreatedDate] [datetime] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FNOL_ClaimItems] ADD CONSTRAINT [PK_FNOL_ClaimItems] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_claimid] ON [dbo].[FNOL_ClaimItems] ([ClaimID]) ON [PRIMARY]
GO
