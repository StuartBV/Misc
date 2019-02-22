CREATE TABLE [dbo].[Invoicing_Order_Charges]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[InvoiceId] [int] NOT NULL,
[DeliveryId] [int] NULL,
[FulfilmentType] [int] NOT NULL,
[ServiceCode] [int] NOT NULL,
[PriceNet] [money] NOT NULL,
[PriceGross] AS (CONVERT([money],round([PriceNet]*[VatRate],(2)),(0))),
[VatRate] [decimal] (4, 2) NOT NULL,
[CreateDate] [datetime] NOT NULL,
[CreatedBy] [dbo].[UserID] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoicing_Order_Charges] ADD CONSTRAINT [PK_INVOICING_Order_Charges] PRIMARY KEY NONCLUSTERED  ([Id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Order_Charges] ON [dbo].[Invoicing_Order_Charges] ([DeliveryId], [InvoiceId], [VatRate], [PriceNet], [PriceGross]) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [InvoiceID] ON [dbo].[Invoicing_Order_Charges] ([InvoiceId], [FulfilmentType]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
