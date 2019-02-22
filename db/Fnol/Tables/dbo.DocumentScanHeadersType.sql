CREATE TABLE [dbo].[DocumentScanHeadersType]
(
[ScanID] [int] NOT NULL,
[DocType] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_scan] ON [dbo].[DocumentScanHeadersType] ([ScanID], [DocType]) ON [PRIMARY]
GO
