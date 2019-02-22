CREATE TABLE [dbo].[Users]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [dbo].[UserID] NOT NULL,
[Role] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthLimit] [int] NULL,
[assetoverride] [tinyint] NULL CONSTRAINT [DF__Users__assetover__25DB9BFC] DEFAULT ((0)),
[ViewAllReminders] [tinyint] NULL CONSTRAINT [DF__Users__ViewAllRe__27C3E46E] DEFAULT ((0)),
[PrimeUser] [tinyint] NULL CONSTRAINT [DF__Users__PrimeUser__28B808A7] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED  ([ID], [UserID]) ON [PRIMARY]
GO
