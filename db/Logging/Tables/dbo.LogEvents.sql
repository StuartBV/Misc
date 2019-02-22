CREATE TABLE [dbo].[LogEvents]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EventID] [int] NOT NULL,
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogEvents] ADD CONSTRAINT [PK_LogEvents] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
