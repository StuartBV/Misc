CREATE TABLE [dbo].[Reports]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Daterange] [tinyint] NULL CONSTRAINT [DF_Reports_Daterange] DEFAULT ((0)),
[Channel] [tinyint] NULL CONSTRAINT [DF_Reports_Channel] DEFAULT ((0)),
[Team] [tinyint] NULL CONSTRAINT [DF_Reports_Team] DEFAULT ((0)),
[Handler] [tinyint] NULL CONSTRAINT [DF_Reports_Handler] DEFAULT ((0)),
[Graph] [tinyint] NULL CONSTRAINT [DF_Reports_Graph] DEFAULT ((0)),
[GraphType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [tinyint] NULL CONSTRAINT [DF_Reports_Enabled] DEFAULT ((1)),
[CreateDate] [datetime] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports] ADD CONSTRAINT [PK_Reports] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
