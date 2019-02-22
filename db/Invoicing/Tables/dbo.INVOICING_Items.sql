CREATE TABLE [dbo].[INVOICING_Items]
(
[OrderId] [int] NOT NULL,
[ItemId] [int] NOT NULL IDENTITY(1, 1),
[DeliveryId] [int] NULL,
[DeliveryItemId] [int] NULL,
[InvoiceId] AS ([OrderID]),
[SourceKey] [int] NULL,
[SourceType] [tinyint] NULL,
[ProductCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Make] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Model] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceNet] [money] NOT NULL,
[PriceGross] AS (round(CONVERT([money],[PriceNet]*[VATRate],(0)),(2))),
[VATRate] [decimal] (4, 2) NOT NULL,
[Status] [tinyint] NOT NULL CONSTRAINT [DF_InvoicingItemsStatus] DEFAULT ((0)),
[Installation] [tinyint] NOT NULL CONSTRAINT [DF_InvoicingItemsInstallation] DEFAULT ((0)),
[Category] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemReference] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_InvoicingItemsCreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL,
[VatDeducted] [money] NOT NULL CONSTRAINT [DF_VatDeducted] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INVOICING_Items] ADD CONSTRAINT [PK_INVOICING_Items] PRIMARY KEY CLUSTERED  ([OrderId], [ItemId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_DeliveryId] ON [dbo].[INVOICING_Items] ([DeliveryId]) ON [PRIMARY]
GO
