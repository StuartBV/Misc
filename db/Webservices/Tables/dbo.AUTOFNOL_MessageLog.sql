CREATE TABLE [dbo].[AUTOFNOL_MessageLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[createdate] [datetime] NULL CONSTRAINT [DF_AutoFNOL_MessageLog_createdate] DEFAULT (getdate()),
[original_message] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transformed_message] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[insuranceclaimno] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pushedtoppd3] [datetime] NULL,
[CMS_ClaimID] [int] NULL,
[PDF_Created] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AUTOFNOL_MessageLog] ADD CONSTRAINT [PK_AUTOFNOL_MessageLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_claimno] ON [dbo].[AUTOFNOL_MessageLog] ([CMS_ClaimID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_insclaimno] ON [dbo].[AUTOFNOL_MessageLog] ([insuranceclaimno]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_status] ON [dbo].[AUTOFNOL_MessageLog] ([status]) ON [PRIMARY]
GO
