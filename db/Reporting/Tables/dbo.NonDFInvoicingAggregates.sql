CREATE TABLE [dbo].[NonDFInvoicingAggregates]
(
[ClaimID] [int] NOT NULL,
[Total] [money] NOT NULL,
[Commodity] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NonDFInvoicingAggregates] ADD CONSTRAINT [PK_NonDFInvoicingAggregates] PRIMARY KEY CLUSTERED  ([ClaimID], [Total]) ON [PRIMARY]
GO
