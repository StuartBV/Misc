CREATE TABLE [dbo].[Invoicing_ExportLog]
(
[invoicenumber] [int] NOT NULL,
[total] [money] NULL,
[vat] [money] NULL,
[createdate] [smalldatetime] NULL CONSTRAINT [DF_Invoicing_ExportLog_createdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoicing_ExportLog] ADD CONSTRAINT [PK_Invoicing_ExportLog] PRIMARY KEY CLUSTERED  ([invoicenumber]) ON [PRIMARY]
GO
