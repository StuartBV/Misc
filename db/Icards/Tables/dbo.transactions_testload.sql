CREATE TABLE [dbo].[transactions_testload]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CardID] [int] NULL,
[CardValue] [money] NULL,
[Type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [smallint] NULL,
[UploadError] [tinyint] NULL,
[AuthRequirement] [smallint] NULL,
[AuthBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthDate] [datetime] NULL,
[BatchFileUploaded] [datetime] NULL,
[InvoicedDate] [datetime] NULL,
[InvoiceValue] [money] NULL,
[InvoiceBatchNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[origValue] [money] NULL,
[Incentive] [tinyint] NULL,
[IncentiveRate] [smallmoney] NULL,
[batchFileUploadNo] [int] NULL
) ON [PRIMARY]
GO
