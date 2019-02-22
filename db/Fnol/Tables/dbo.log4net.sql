CREATE TABLE [dbo].[log4net]
(
[Date] [datetime] NOT NULL,
[Thread] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[level] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[logger] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[exception] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Portal] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [idx_date] ON [dbo].[log4net] ([Date]) ON [PRIMARY]
GO
