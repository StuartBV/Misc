CREATE TABLE [dbo].[wip_report]
(
[tier] [smallint] NULL,
[status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total] [int] NULL,
[weekstart] [smalldatetime] NULL,
[week] [smallint] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [Idx_WeekStart] ON [dbo].[wip_report] ([weekstart]) ON [PRIMARY]
GO
