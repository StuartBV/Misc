CREATE TABLE [dbo].[Invoicing_InvoiceExport_Sage_Log]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TransType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NominalCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Department] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvoiceDate] [datetime] NOT NULL,
[InvoiceNumber] [int] NOT NULL,
[Reference] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Amount] [decimal] (8, 2) NOT NULL,
[VatCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Vat] [decimal] (8, 2) NOT NULL,
[Type] [tinyint] NOT NULL CONSTRAINT [DF_InvoiceExport_Sage_Log_Type] DEFAULT ((0)),
[Createdate] [datetime] NOT NULL CONSTRAINT [DF_InvoiceExport_Sage_Log_Createdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoicing_InvoiceExport_Sage_Log] ADD CONSTRAINT [PK_Invoicing_InvoiceExport_Sage_Log] PRIMARY KEY NONCLUSTERED  ([Id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [Idx_InvoiceNumber] ON [dbo].[Invoicing_InvoiceExport_Sage_Log] ([Createdate], [InvoiceNumber], [Type]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'0=line items 1=aggregated', 'SCHEMA', N'dbo', 'TABLE', N'Invoicing_InvoiceExport_Sage_Log', 'COLUMN', N'Type'
GO
