CREATE TABLE [dbo].[MessageLog]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[SourceSystem] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MessageLog_SourceSystem] DEFAULT ('CMS'),
[SourceKey] [int] NOT NULL,
[SupplierID] [int] NOT NULL,
[MessageType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MessageLog_MessageType] DEFAULT ('E'),
[MessageID] [int] NOT NULL,
[ItemsHash] [char] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateSent] [datetime] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_MessageLog_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_MessageLog_CreatedBy] DEFAULT ('sys'),
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [Data]
GO
ALTER TABLE [dbo].[MessageLog] ADD CONSTRAINT [PK_MessageLog] PRIMARY KEY CLUSTERED  ([LogID]) WITH (FILLFACTOR=100) ON [Data]
GO
CREATE NONCLUSTERED INDEX [Idx_MessageID] ON [dbo].[MessageLog] ([MessageID]) WITH (FILLFACTOR=95, PAD_INDEX=ON) ON [Indexes]
GO
CREATE NONCLUSTERED INDEX [Idx_SourceKey] ON [dbo].[MessageLog] ([SourceKey], [SupplierID], [MessageType], [MessageID]) WITH (FILLFACTOR=95, PAD_INDEX=ON) ON [Indexes]
GO
CREATE STATISTICS [Statistic_ItemsHash] ON [dbo].[MessageLog] ([ItemsHash], [SourceKey], [SupplierID], [MessageType], [MessageID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'E=estimate I=invoice', 'SCHEMA', N'dbo', 'TABLE', N'MessageLog', 'COLUMN', N'MessageType'
GO
