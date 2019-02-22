CREATE TABLE [dbo].[NonSSOLogons]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [dbo].[UserID] NOT NULL,
[SourceSystem] [tinyint] NOT NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_NonSSOLogons_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NonSSOLogons] ADD CONSTRAINT [PK_NonSSOLogons] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'1) CMS
2) Validator', 'SCHEMA', N'dbo', 'TABLE', N'NonSSOLogons', 'COLUMN', N'SourceSystem'
GO
