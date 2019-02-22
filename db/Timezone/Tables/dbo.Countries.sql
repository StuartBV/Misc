CREATE TABLE [dbo].[Countries]
(
[Code] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Countries] ADD CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED  ([Code]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
