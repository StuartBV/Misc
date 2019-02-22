CREATE TABLE [dbo].[Worktable_InvoiceExport_Sage]
(
[TransType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceDate] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Reference] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Amount] [decimal] (8, 2) NULL,
[VatCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vat] [decimal] (8, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Worktable_InvoiceExport_Sage] ADD CONSTRAINT [PK_Worktable_InvoiceExport_Sage] PRIMARY KEY CLUSTERED  ([InvoiceNumber]) ON [PRIMARY]
GO
