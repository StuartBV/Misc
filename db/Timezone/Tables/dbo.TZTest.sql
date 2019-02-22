CREATE TABLE [dbo].[TZTest]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateTime] [datetime] NOT NULL,
[SmallDateTime] [smalldatetime] NOT NULL,
[DateTimeOffset] [datetimeoffset] NOT NULL,
[TimeZone] [smallint] NOT NULL,
[TestResult] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TZTest] ADD CONSTRAINT [PK_TZTest] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
