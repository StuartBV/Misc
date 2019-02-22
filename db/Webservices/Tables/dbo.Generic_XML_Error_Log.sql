CREATE TABLE [dbo].[Generic_XML_Error_Log]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ClaimID] [int] NULL,
[SupplierID] [int] NULL,
[MessageType] [int] NULL,
[ErrorMsg] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Generic_XML_Error_Log_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Generic_XML_Error_Log] ADD CONSTRAINT [PK_Generic_XML_Error_Log] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_ClaimID] ON [dbo].[Generic_XML_Error_Log] ([ClaimID]) ON [PRIMARY]
GO
