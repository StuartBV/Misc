CREATE TABLE [dbo].[GPReportAggregates]
(
[ClaimID] [int] NOT NULL,
[TAC] [money] NULL,
[Vouchered] [money] NULL,
[Settled] [money] NULL,
[NetUpgrade] [money] NULL,
[NetSS] [money] NULL,
[ValidationFeesNet] [smallmoney] NULL,
[FeeOnly] [tinyint] NULL,
[TotalItems] [int] NULL,
[SentItems] [int] NULL,
[SuppliedValue] [money] NULL,
[Pre08XS] [smallmoney] NULL CONSTRAINT [DF_GPReportAggregates_Pre08XS] DEFAULT ((0)),
[InvNetProduct] [money] NULL CONSTRAINT [DF_GPReportAggregates_InvNetProduct] DEFAULT ((0)),
[InvNetTotal] [money] NULL CONSTRAINT [DF_GPReportAggregates_InvNetTotal] DEFAULT ((0)),
[Fees] [money] NULL,
[InvoiceSent] [dbo].[PPDate] NULL,
[OfficeGroupID] [tinyint] NULL CONSTRAINT [DF_GPReportAggregates_OfficeGroupID] DEFAULT ((0)),
[CreateDate] [smalldatetime] NOT NULL CONSTRAINT [DF_GPReportAggregates_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GPReportAggregates] ADD CONSTRAINT [PK_GPReportAggregates] PRIMARY KEY CLUSTERED  ([ClaimID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_Fees] ON [dbo].[GPReportAggregates] ([ValidationFeesNet], [FeeOnly], [ClaimID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'From Invoice Table (This will include CHF where it exists, mimicing the use of these two values as they were used by the GP reports)', 'SCHEMA', N'dbo', 'TABLE', N'GPReportAggregates', 'COLUMN', N'InvNetProduct'
GO
EXEC sp_addextendedproperty N'MS_Description', N'From Invoice Table', 'SCHEMA', N'dbo', 'TABLE', N'GPReportAggregates', 'COLUMN', N'InvNetTotal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Special column. Because invoicing was changed at the start of 08, for GP report to work on 07 claims it needs to add the net XS value to the inv total with the old rules', 'SCHEMA', N'dbo', 'TABLE', N'GPReportAggregates', 'COLUMN', N'Pre08XS'
GO
