CREATE TABLE [dbo].[JewelleryCopyToInvoiceLog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ClaimId] [int] NULL,
[Prodid] [int] NULL,
[RRP] [smallmoney] NULL,
[Price] [smallmoney] NULL,
[AverageCost] [smallmoney] NULL,
[Discount] [real] NULL,
[VatRate] [decimal] (6, 4) NULL,
[Weight] [decimal] (7, 2) NULL,
[DoNotInvoice] [bit] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_JewelleryCopyToInvoiceLog_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JewelleryCopyToInvoiceLog] ADD CONSTRAINT [PK_JewelleryCopyToInvoiceLog] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [PRIMARY]
GO
