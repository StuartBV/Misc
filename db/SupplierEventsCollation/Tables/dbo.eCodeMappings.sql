CREATE TABLE [dbo].[eCodeMappings]
(
[SupplierID] [int] NOT NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_eCodeMappings_Channel] DEFAULT ('*'),
[eCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SupplierName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierNameForXML] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rank] AS (case  when [Channel]='*' then (0) else (2) end),
[CreateDate] [smalldatetime] NOT NULL CONSTRAINT [DF_eCodeMappings_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_eCodeMappings_CreatedBy] DEFAULT ('Sys')
) ON [Data]
GO
ALTER TABLE [dbo].[eCodeMappings] ADD CONSTRAINT [PK_eCodeMappings] PRIMARY KEY CLUSTERED  ([SupplierID], [Channel]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [Data]
GO
