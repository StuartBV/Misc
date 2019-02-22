CREATE TABLE [dbo].[TeamLookups]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team] [smallint] NULL,
[code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[answerid] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TeamLookups] ADD CONSTRAINT [PK_TeamLookups] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
