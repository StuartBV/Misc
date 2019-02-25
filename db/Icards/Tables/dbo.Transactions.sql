CREATE TABLE [dbo].[Transactions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CardID] [int] NULL,
[CardValue] [money] NULL CONSTRAINT [DF_card_values_CardValue] DEFAULT ((0)),
[Type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [smallint] NULL CONSTRAINT [DF_card_values_Status] DEFAULT ((0)),
[UploadError] [tinyint] NULL,
[AuthRequirement] [smallint] NULL CONSTRAINT [DF_card_values_AuthRequirement] DEFAULT ((0)),
[AuthBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthDate] [datetime] NULL,
[BatchFileUploaded] [datetime] NULL,
[InvoicedDate] [datetime] NULL,
[InvoiceValue] [money] NULL,
[InvoiceBatchNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Card_values_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[origValue] [money] NULL,
[Incentive] [tinyint] NULL,
[IncentiveRate] [smallmoney] NULL,
[batchFileUploadNo] [int] NULL,
[AdjustmentReason] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[InvoicedDate] ON [dbo].[Transactions]
FOR  UPDATE
AS
if update (InvoicedDate)
begin
	update t set t.altereddate=getdate(), t.alteredby='invoiceexport'
	from inserted i 
	join transactions t on t.ID=i.ID
	where i.InvoicedDate is not null	
end

GO
ALTER TABLE [dbo].[Transactions] ADD CONSTRAINT [PK_card_values] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_cardid] ON [dbo].[Transactions] ([CardID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CardValue] ON [dbo].[Transactions] ([CardID], [CardValue], [Status]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Batchno] ON [dbo].[Transactions] ([InvoiceBatchNo], [Status], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'Transactions', 'COLUMN', N'AuthRequirement'
GO
