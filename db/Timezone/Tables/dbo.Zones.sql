CREATE TABLE [dbo].[Zones]
(
[Code] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comments] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ID] [smallint] NOT NULL IDENTITY(10, 10),
[Enabled] [bit] NULL CONSTRAINT [DF_Zones_Enabled] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Zones] ADD CONSTRAINT [PK_Zones_1] PRIMARY KEY CLUSTERED  ([ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
