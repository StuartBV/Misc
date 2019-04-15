CREATE TABLE [dbo].[InvoicesToExport]
(
[Id] [bigint] NOT NULL,
[OrderId] [int] NOT NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_InvoicesToExport_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoicesToExport] ADD CONSTRAINT [PK_InvoicesToExport] PRIMARY KEY CLUSTERED  ([Id], [OrderId]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
