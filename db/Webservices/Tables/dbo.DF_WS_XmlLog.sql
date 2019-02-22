CREATE TABLE [dbo].[DF_WS_XmlLog]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[DID] [int] NOT NULL,
[ClaimID] [int] NOT NULL,
[SupplierID] [int] NULL,
[Direction] [tinyint] NOT NULL,
[MsgType] [tinyint] NOT NULL CONSTRAINT [DF_DF_WS_XmlLog_MsgType] DEFAULT ((0)),
[SourceSystem] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DF_WS_XmlLog_SourceSystem] DEFAULT ('CMS'),
[GUID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[XML] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_DF_WS_XmlLog_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DF_WS_XmlLog] ADD CONSTRAINT [PK_DF_WS_XmlLog] PRIMARY KEY NONCLUSTERED  ([LogID]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [Idx_CreateDate] ON [dbo].[DF_WS_XmlLog] ([CreateDate]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Direction] ON [dbo].[DF_WS_XmlLog] ([Direction]) INCLUDE ([CreateDate], [DID]) ON [PRIMARY]
GO
