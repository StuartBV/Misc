CREATE TABLE [dbo].[AUTOFNOL_LossAdjusters]
(
[LossAdjusterID] [int] NOT NULL IDENTITY(1, 1),
[MessageID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mphone] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherInformation] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_AUTOFNOL_LossAdjusters_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_AUTOFNOL_LossAdjusters_CreatedBy] DEFAULT ('sys'),
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AUTOFNOL_LossAdjusters] ADD CONSTRAINT [PK_AUTOFNOL_LossAdjusters] PRIMARY KEY CLUSTERED  ([LossAdjusterID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_MessageID] ON [dbo].[AUTOFNOL_LossAdjusters] ([MessageID]) ON [PRIMARY]
GO
