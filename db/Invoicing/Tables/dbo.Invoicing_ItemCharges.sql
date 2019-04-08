CREATE TABLE [dbo].[Invoicing_ItemCharges]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ItemId] [int] NOT NULL,
[Type] [tinyint] NOT NULL,
[Catnum] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeliveryId] [int] NULL,
[DeliveryItemId] [int] NULL,
[SupplierChargeId] [int] NOT NULL,
[PriceNet] [money] NOT NULL,
[PriceGross] AS (CONVERT([money],round([PriceNet]*[VatRate],(2)),(0))),
[VatRate] [decimal] (4, 2) NOT NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Invoicing_createDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoicing_ItemCharges] ADD CONSTRAINT [PK_INVOICING_ItemCharges] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_DeliveryId] ON [dbo].[Invoicing_ItemCharges] ([DeliveryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ItemID] ON [dbo].[Invoicing_ItemCharges] ([ItemId]) INCLUDE ([PriceNet], [VatRate]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ItemCharges] ON [dbo].[Invoicing_ItemCharges] ([VatRate], [DeliveryId], [Type], [PriceNet], [PriceGross]) ON [PRIMARY]
GO
