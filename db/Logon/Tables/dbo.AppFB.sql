CREATE TABLE [dbo].[AppFB]
(
[ID] [bigint] NOT NULL IDENTITY(1, 1),
[AppID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimID] [bigint] NULL,
[helpful] [tinyint] NULL,
[rcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[feedback] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_AppFB_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_AppFB_CreatedBy] DEFAULT ('SYS')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppFB] ADD CONSTRAINT [PK_AppFB] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
