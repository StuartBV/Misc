CREATE TABLE [dbo].[Users]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RoleID] [int] NULL,
[Team] [int] NULL,
[CallAllowance] [tinyint] NULL CONSTRAINT [DF_Users_CallAllowance] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_team] ON [dbo].[Users] ([UserID], [RoleID], [Team]) ON [PRIMARY]
GO
