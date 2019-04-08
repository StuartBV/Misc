CREATE TABLE [dbo].[InvoiceExport_NominalCodes_Map]
(
[Id] [smallint] NOT NULL IDENTITY(1, 1),
[NominalCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CategoryId] [smallint] NOT NULL,
[SupplierId] [int] NOT NULL CONSTRAINT [DF_InvoiceExport_NominalCodes_Map_SupplierId] DEFAULT ((0)),
[IsJewellery] [bit] NOT NULL CONSTRAINT [DF_InvoiceExport_NominalCodes_Map_IsJewellery] DEFAULT ((0)),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_InvoiceExport_NominalCodes_Map_CreateDate] DEFAULT (getdate()),
[createdby] [dbo].[UserID] NOT NULL CONSTRAINT [DF_InvoiceExport_NominalCodes_Map_createdby] DEFAULT ('sys')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceExport_NominalCodes_Map] ADD CONSTRAINT [PK_InvoiceExport_NominalCodes_Map_1] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'All rows also join to suppliers and where this flag and IsJewellery match', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceExport_NominalCodes_Map', 'COLUMN', N'IsJewellery'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Join to this row specifically for the supplierID for the order', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceExport_NominalCodes_Map', 'COLUMN', N'SupplierId'
GO
