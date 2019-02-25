CREATE TABLE [dbo].[LastRef]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[userID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastFrame] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LastRef] ADD CONSTRAINT [PK_LastRef] PRIMARY KEY CLUSTERED  ([userID]) ON [PRIMARY]
GO
