CREATE TABLE [dbo].[Fees]
(
[InvoiceID] [int] NOT NULL IDENTITY(1, 1),
[BordereauNo] [smallint] NULL,
[ClaimID] [int] NOT NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FeeType] [tinyint] NOT NULL CONSTRAINT [DF_Fees_FeeType] DEFAULT ((0)),
[InvoiceType] [tinyint] NULL CONSTRAINT [DF_Fees_InvoiceType] DEFAULT ((0)),
[Gross] [smallmoney] NULL,
[Net] [smallmoney] NULL,
[Vat] [smallmoney] NULL,
[InvoiceSent] [datetime] NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_Fees_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Fees] ADD CONSTRAINT [PK_Fees] PRIMARY KEY CLUSTERED  ([ClaimID], [Channel], [FeeType]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Bordereau the fee has been sent on', 'SCHEMA', N'dbo', 'TABLE', N'Fees', 'COLUMN', N'BordereauNo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'channel of claim', 'SCHEMA', N'dbo', 'TABLE', N'Fees', 'COLUMN', N'Channel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Claim reference', 'SCHEMA', N'dbo', 'TABLE', N'Fees', 'COLUMN', N'ClaimID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0=Fraud Fee (Default)', 'SCHEMA', N'dbo', 'TABLE', N'Fees', 'COLUMN', N'FeeType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Gross invoice amount', 'SCHEMA', N'dbo', 'TABLE', N'Fees', 'COLUMN', N'Gross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of invoice sent', 'SCHEMA', N'dbo', 'TABLE', N'Fees', 'COLUMN', N'InvoiceSent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0=Bordereau (Default)', 'SCHEMA', N'dbo', 'TABLE', N'Fees', 'COLUMN', N'InvoiceType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Net invoice amount', 'SCHEMA', N'dbo', 'TABLE', N'Fees', 'COLUMN', N'Net'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Vat invoice amount', 'SCHEMA', N'dbo', 'TABLE', N'Fees', 'COLUMN', N'Vat'
GO
