CREATE TABLE [dbo].[Data_Item]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MessageID] [int] NOT NULL,
[SourceSystem] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Data_Item_SourceSystem] DEFAULT ('CMS'),
[EventID] [int] NOT NULL,
[SupplierID] [int] NOT NULL,
[SourceKey] [int] NOT NULL,
[ItemID] [int] NULL,
[ProdID] [int] NULL,
[NetPrice] [smallmoney] NULL,
[VatRate] [decimal] (5, 3) NULL,
[CatNum] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemTypeCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Data_Item_ItemTypeCode] DEFAULT (''),
[ProductHash] [char] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemCreateDate] [smalldatetime] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_ItemData_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_ItemData_CreatedBy] DEFAULT ('sys'),
[VatAmount] [smallmoney] NULL
) ON [Data]
GO
ALTER TABLE [dbo].[Data_Item] ADD CONSTRAINT [PK_ItemData] PRIMARY KEY CLUSTERED  ([MessageID], [ID]) WITH (FILLFACTOR=95) ON [Data]
GO
CREATE NONCLUSTERED INDEX [Idx_EventId] ON [dbo].[Data_Item] ([EventID]) WITH (FILLFACTOR=95, PAD_INDEX=ON) ON [Indexes]
GO
