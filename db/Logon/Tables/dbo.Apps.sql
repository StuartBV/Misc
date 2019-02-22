CREATE TABLE [dbo].[Apps]
(
[AID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[URL] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Apps_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OpenInParent] [tinyint] NOT NULL CONSTRAINT [DF_Apps_OpenInParent] DEFAULT ((0)),
[Enabled] [bit] NOT NULL CONSTRAINT [DF_Apps_Enabled] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Apps] ADD CONSTRAINT [PK_Apps] PRIMARY KEY CLUSTERED  ([AID]) ON [PRIMARY]
GO
