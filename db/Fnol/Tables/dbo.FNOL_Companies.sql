CREATE TABLE [dbo].[FNOL_Companies]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Company] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[logo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FNOL_Companies] ADD CONSTRAINT [PK_FNOL_Companies] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
