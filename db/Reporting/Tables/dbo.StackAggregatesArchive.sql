CREATE TABLE [dbo].[StackAggregatesArchive]
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
[CreateDate] [smalldatetime] NOT NULL CONSTRAINT [DF_StackAggregatesArchive_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StackAggregatesArchive] ADD CONSTRAINT [PK_StackAggregatesArchive] PRIMARY KEY NONCLUSTERED  ([ClaimID], [Superfmt], [Channel]) WITH (FILLFACTOR=95, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [idx_Date] ON [dbo].[StackAggregatesArchive] ([CreateDate], [ClaimID], [Superfmt]) WITH (FILLFACTOR=99, PAD_INDEX=ON) ON [PRIMARY]
GO
