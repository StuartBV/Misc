CREATE TABLE [dbo].[MI_NU_ClaimSuperFmt]
(
[ClaimID] [int] NOT NULL,
[SuperFmt] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MI_NU_ClaimSuperFmt] ADD CONSTRAINT [PK_MI_NU_ClaimSuperFmt] PRIMARY KEY CLUSTERED  ([ClaimID], [SuperFmt]) ON [PRIMARY]
GO
