CREATE TABLE [dbo].[SupplierInvoiceMatch]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ReportNo] [int] NOT NULL,
[UserID] [dbo].[UserID] NOT NULL,
[SupplierID] [int] NOT NULL,
[SupplierRef] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClaimID] [int] NULL CONSTRAINT [DF_SupplierInvoiceMatch_ClaimID] DEFAULT ((0)),
[DID] [int] NULL CONSTRAINT [DF_SupplierInvoiceMatch_DID] DEFAULT ((0)),
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderNo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceDate] [smalldatetime] NULL,
[InvoiceTotal] [smallmoney] NULL CONSTRAINT [DF_SupplierInvoiceMatch_InvoiceTotal] DEFAULT ((0)),
[OrderTotal] [smallmoney] NULL CONSTRAINT [DF_SupplierInvoiceMatch_POTotal] DEFAULT ((0)),
[Variance] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SupplierInvoiceMatch_Variance] DEFAULT ((0)),
[MatchCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SupplierInvoiceMatch_MatchCode] DEFAULT ('UM'),
[Commodity] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processed] [tinyint] NULL CONSTRAINT [DF_SupplierInvoiceMatch_Processed] DEFAULT ((0)),
[OriginatingSystem] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceType] [tinyint] NULL CONSTRAINT [DF_SupplierInvoiceMatch_InvoiceType] DEFAULT ((1)),
[PreviouslyChecked] [bit] NULL CONSTRAINT [DF_SupplierInvoiceMatch_PreviouslyChecked] DEFAULT ((0)),
[PreviouslyCheckedBy] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_SupplierInvoiceMatch_PreviouslyCheckedBy] DEFAULT (''),
[ExportedDate] [datetime] NULL,
[InvoiceNetTotal] [smallmoney] NULL CONSTRAINT [DF_SupplierInvoiceMatch_InvoiceTotal1] DEFAULT ((0)),
[InvoiceVat] [smallmoney] NULL,
[Notes] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckId] [int] NULL,
[InvoiceId] [int] NULL,
[SpExcess] [smallmoney] NULL,
[Discount] [decimal] (8, 2) NULL,
[CreateDate] [smalldatetime] NOT NULL CONSTRAINT [DF_SupplierInvoiceMatch_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[TR_SupplierInvoiceMatch_Delete] on [dbo].[SupplierInvoiceMatch]
for delete as
if @@rowcount = 0 return
set nocount on

delete from a
from deleted d join SupplierInvoicingAggregates a on a.ReportNo=d.ReportNo
GO
ALTER TABLE [dbo].[SupplierInvoiceMatch] ADD CONSTRAINT [PK_SupplierInvoiceMatch] PRIMARY KEY NONCLUSTERED  ([ID]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_CreateDate] ON [dbo].[SupplierInvoiceMatch] ([CreateDate]) INCLUDE ([ID]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Did] ON [dbo].[SupplierInvoiceMatch] ([DID], [SupplierRef]) INCLUDE ([ClaimID], [ID], [InvoiceTotal], [SupplierID]) WITH (FILLFACTOR=98, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [Idx_ReportNo] ON [dbo].[SupplierInvoiceMatch] ([ReportNo], [DID], [ID]) WITH (FILLFACTOR=98, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_ReportNo_2] ON [dbo].[SupplierInvoiceMatch] ([ReportNo], [SupplierRef], [ClaimID], [SupplierID], [DID]) INCLUDE ([ID], [InvoiceTotal]) WITH (FILLFACTOR=98) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_SupplierRef] ON [dbo].[SupplierInvoiceMatch] ([SupplierRef]) INCLUDE ([ID]) WITH (FILLFACTOR=90, PAD_INDEX=ON) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'See ppd3..Syslookup Tablename=''SupplierInvoiceType''', 'SCHEMA', N'dbo', 'TABLE', N'SupplierInvoiceMatch', 'COLUMN', N'InvoiceType'
GO
