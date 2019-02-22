CREATE TABLE [dbo].[OrderItemsAddLog]
(
[uID] [int] NOT NULL IDENTITY(1, 1),
[OIID] [int] NOT NULL,
[ClaimID] [int] NOT NULL,
[Type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProdID] [int] NULL,
[Qty] [int] NULL,
[UserID] [dbo].[UserID] NULL,
[CustPrice] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustRRP] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sent] [tinyint] NULL,
[Mode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OverridePrice] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SALOverride] [int] NULL,
[CustomDiscount] [int] NULL,
[FFDCheckPerformed] [int] NULL,
[InternalValues ->] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_OrderItemsLog_InternalValues ->] DEFAULT ('|'),
[RRP] [smallmoney] NULL,
[Price] [smallmoney] NULL,
[OverridePriceValue] [smallmoney] NULL,
[PPDiscount] [decimal] (10, 4) NULL,
[InscoDesc] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [smallint] NULL,
[StockStatus] [smallint] NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllowanceExclude] [tinyint] NULL,
[CurrencyID] [tinyint] NULL,
[Vatrate] [decimal] (6, 4) NULL,
[UpgradeEnabled] [bit] NULL,
[ValidatedSupplier] [bit] NULL,
[PPRuleID] [int] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_OrderItemsLog_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrderItemsAddLog] ADD CONSTRAINT [PK_OrderItemsLog] PRIMARY KEY CLUSTERED  ([uID]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_ClaimID] ON [dbo].[OrderItemsAddLog] ([ClaimID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_OIID] ON [dbo].[OrderItemsAddLog] ([OIID]) ON [PRIMARY]
GO
