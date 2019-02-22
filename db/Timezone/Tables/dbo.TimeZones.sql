CREATE TABLE [dbo].[TimeZones]
(
[ID] [smallint] NOT NULL,
[Code] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTime] [datetime2] (0) NOT NULL,
[LocalStartTime] AS (dateadd(second,[offset],[starttime])),
[Offset] [int] NOT NULL,
[OffsetMinutes] AS (CONVERT([decimal](4,1),CONVERT([decimal](6,1),[offset],(0))/(60),(0))),
[OffsetHours] AS (CONVERT([decimal](3,1),(CONVERT([decimal](6,1),[offset],(0))/(60))/(60),(0))),
[DST] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TimeZones] ADD CONSTRAINT [PK_TimeZones] PRIMARY KEY CLUSTERED  ([ID], [StartTime] DESC) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
