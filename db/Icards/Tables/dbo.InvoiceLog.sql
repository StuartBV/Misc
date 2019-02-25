CREATE TABLE [dbo].[InvoiceLog]
(
[BatchNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XML] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_InvoiceLog_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
