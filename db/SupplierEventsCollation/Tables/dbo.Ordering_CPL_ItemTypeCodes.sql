CREATE TABLE [dbo].[Ordering_CPL_ItemTypeCodes]
(
[uid] [int] NOT NULL IDENTITY(1, 1),
[Category] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Method] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Ordering_CPL_ItemTypeCodes_Method] DEFAULT ('P'),
[Segment1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Segment2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPLDescription] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPLCode] AS (isnull([Segment2],'?')+isnull([Segment1],'?')),
[CreateDate] [smalldatetime] NULL CONSTRAINT [DF_Ordering_CPL_ItemTypeCodes_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NULL CONSTRAINT [DF_Ordering_CPL_ItemTypeCodes_CreatedBy] DEFAULT ('sys')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ordering_CPL_ItemTypeCodes] ADD CONSTRAINT [PK_Ordering_CPL_ItemTypeCodes] PRIMARY KEY CLUSTERED  ([Category], [Method]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
