CREATE TABLE [dbo].[LV_CashSettlementExport]
(
[LMGJobNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PolicyExcess] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReplacedItems] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasExcessBeenDeducted] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalCashReferralValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LVComments] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
