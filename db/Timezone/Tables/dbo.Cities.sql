CREATE TABLE [dbo].[Cities]
(
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Code] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TimeZoneID] [smallint] NOT NULL CONSTRAINT [DF_Cities_TimeZoneID] DEFAULT ((1610))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cities] ADD CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED  ([City]) ON [PRIMARY]
GO
