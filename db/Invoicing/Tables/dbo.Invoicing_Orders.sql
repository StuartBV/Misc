CREATE TABLE [dbo].[Invoicing_Orders]
(
[Id] [int] NOT NULL IDENTITY(10000, 1),
[CustomerId] [int] NULL,
[InscoID] [int] NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryId] [int] NULL,
[SupplierId] [int] NOT NULL,
[CountryId] [tinyint] NULL CONSTRAINT [DF__INVOICINGOrders_countryID] DEFAULT ((0)),
[SourceKey] [int] NOT NULL,
[SourceType] [tinyint] NOT NULL,
[Reference] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [tinyint] NOT NULL CONSTRAINT [DF__INVOICINGOrders_Status] DEFAULT ((0)),
[Category] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BordereauNo] [int] NULL,
[OrderDate] [datetime] NULL,
[OrderSentDate] [datetime] NULL,
[SageSentDate] [smalldatetime] NULL,
[BordereauSentDate] [smalldatetime] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__INVOICINGOrders_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoicing_Orders] ADD CONSTRAINT [PK_INVOICING_Order] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BordereauNo] ON [dbo].[Invoicing_Orders] ([BordereauNo]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DeliveryID] ON [dbo].[Invoicing_Orders] ([DeliveryId], [Id], [CreateDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SageSentDate] ON [dbo].[Invoicing_Orders] ([SageSentDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
