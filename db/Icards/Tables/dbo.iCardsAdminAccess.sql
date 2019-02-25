CREATE TABLE [dbo].[iCardsAdminAccess]
(
[UserID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AdminID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iCardsAdminAccess] ADD CONSTRAINT [PK_OptionsAdminAccess] PRIMARY KEY CLUSTERED  ([UserID], [AdminID]) ON [PRIMARY]
GO
