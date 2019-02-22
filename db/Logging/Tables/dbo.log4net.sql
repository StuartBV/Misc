CREATE TABLE [dbo].[log4net]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Date] [datetime] NOT NULL CONSTRAINT [DF_log4net_Date] DEFAULT (getdate()),
[Thread] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_log4net_Thread] DEFAULT ((0)),
[level] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[logger] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message] [varchar] (7000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[exception] [varchar] (7000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Portal] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IpAddress] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[log4net] ADD CONSTRAINT [PK_log4net] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Date] ON [dbo].[log4net] ([Date], [level]) INCLUDE ([Portal]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [portal] ON [dbo].[log4net] ([Portal], [Date]) ON [PRIMARY]
GO
