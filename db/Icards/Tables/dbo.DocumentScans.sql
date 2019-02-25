CREATE TABLE [dbo].[DocumentScans]
(
[ScanID] [int] NOT NULL IDENTITY(1, 1),
[iCardsID] [int] NULL,
[InitialFax] [tinyint] NULL CONSTRAINT [DF_DocumentScans_InitialFax] DEFAULT ((0)),
[OtherInfo] [tinyint] NULL CONSTRAINT [DF_DocumentScans_OtherInfo] DEFAULT ((0)),
[Printed] [tinyint] NULL CONSTRAINT [DF_DocumentScans_Printed] DEFAULT ((0)),
[PrintedOn] [datetime] NULL,
[Deleted] [tinyint] NULL CONSTRAINT [DF_DocumentScans_Deleted] DEFAULT ((0)),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_DocumentScans_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentScans] ADD CONSTRAINT [PK_DocumentScans] PRIMARY KEY CLUSTERED  ([ScanID]) ON [PRIMARY]
GO
