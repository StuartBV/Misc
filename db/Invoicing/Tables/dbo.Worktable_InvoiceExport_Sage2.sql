CREATE TABLE [dbo].[Worktable_InvoiceExport_Sage2]
(
[TransType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NominalCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Department] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvoiceDate] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvoiceNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Reference] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Amount] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VatCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Vat] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
