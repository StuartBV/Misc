CREATE TABLE [dbo].[AXA_CashSettlementExport]
(
[PowerplayRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AXAClaimRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AXAPolicyNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PHName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PHAddress] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Items] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CashSettledItems] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Outstanding] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TotalDiscounted] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Excess] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExcessToBeDeducted] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExcessInfo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AXAToPayPH] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
