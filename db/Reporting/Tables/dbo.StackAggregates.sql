CREATE TABLE [dbo].[StackAggregates]
(
[ClaimID] [int] NOT NULL,
[Superfmt] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Qty] [smallint] NOT NULL,
[InvoicePriceNet_GBP] [money] NOT NULL,
[InvoicePriceNet] [money] NOT NULL,
[InvoicePriceGross_GBP] [money] NOT NULL,
[InvoicePriceGross] [money] NOT NULL,
[CountryID] [tinyint] NOT NULL,
[PPiD] [int] NOT NULL,
[OrderType] [tinyint] NOT NULL,
[CreateDate] [smalldatetime] NOT NULL CONSTRAINT [DF_StackAggregates_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StackAggregates] ADD CONSTRAINT [PK_StackAggregates] PRIMARY KEY CLUSTERED  ([ClaimID], [Superfmt]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Net value in original currency', 'SCHEMA', N'dbo', 'TABLE', N'StackAggregates', 'COLUMN', N'InvoicePriceNet'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Net value after multiplying by currency convert factor', 'SCHEMA', N'dbo', 'TABLE', N'StackAggregates', 'COLUMN', N'InvoicePriceNet_GBP'
GO
