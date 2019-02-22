CREATE TABLE [dbo].[DocumentScanHeaders]
(
[ScanID] [int] NOT NULL IDENTITY(1, 1),
[ClaimID] [int] NOT NULL,
[Sheets] [int] NOT NULL,
[Printed] [datetime] NULL,
[Uploaded] [datetime] NULL,
[Cancelled] [datetime] NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentScanHeaders] ADD CONSTRAINT [PK_DocumentScanHeaders] PRIMARY KEY CLUSTERED  ([ScanID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_scan] ON [dbo].[DocumentScanHeaders] ([ScanID], [ClaimID]) ON [PRIMARY]
GO
