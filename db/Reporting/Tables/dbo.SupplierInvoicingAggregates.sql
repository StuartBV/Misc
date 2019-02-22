CREATE TABLE [dbo].[SupplierInvoicingAggregates]
(
[ReportNo] [int] NOT NULL,
[DID] [int] NOT NULL,
[ClaimID] [int] NULL CONSTRAINT [DF_SupplierInvoicingAggregates_ClaimID] DEFAULT ((0)),
[Total] [smallmoney] NOT NULL CONSTRAINT [DF_SupplierInvoicingAggregates_Total] DEFAULT ((0)),
[Status] [int] NULL,
[PartCancelled] [tinyint] NOT NULL CONSTRAINT [DF_SupplierInvoicingAggregates_PartCancelled] DEFAULT ((0)),
[Commodity] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginatingSystem] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpExcess] [smallmoney] NULL,
[Discount] [decimal] (8, 2) NULL,
[MatchRef] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_SupplierInvoicingAggregates_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_SupplierInvoicingAggregates_CreatedBy] DEFAULT ('sys')
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [Idx_Did] ON [dbo].[SupplierInvoicingAggregates] ([ReportNo], [DID], [ClaimID]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO
