CREATE TABLE [dbo].[TitleCodeMappings]
(
[CMSTitle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CPLTitleCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CPLTitleDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [smalldatetime] NOT NULL CONSTRAINT [DF_TitleCodeMappings_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_TitleCodeMappings_CreatedBy] DEFAULT ('Sys')
) ON [Data]
GO
ALTER TABLE [dbo].[TitleCodeMappings] ADD CONSTRAINT [PK_TitleCodeMappings] PRIMARY KEY CLUSTERED  ([CMSTitle], [CPLTitleCode]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [Data]
GO
