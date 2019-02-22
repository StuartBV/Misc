CREATE TABLE [dbo].[CometInvoicingAggregates]
(
[ClaimID] [int] NOT NULL,
[Total] [money] NOT NULL,
[Commodity] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CometInvoicingAggregates] ADD CONSTRAINT [PK_CometCardInvoicingAggregates] PRIMARY KEY CLUSTERED  ([ClaimID], [Total]) ON [PRIMARY]
GO
