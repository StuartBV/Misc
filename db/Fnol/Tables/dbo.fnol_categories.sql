CREATE TABLE [dbo].[fnol_categories]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ParentID] [int] NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [tinyint] NOT NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[fnol_categories] ADD CONSTRAINT [PK_fnol_categories] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
