CREATE TABLE [dbo].[Icards_InvoiceQueue]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[batchNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateInvoiced] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Icards_InvoiceQueue] ADD CONSTRAINT [PK_Icards_InvoiceQueue] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
