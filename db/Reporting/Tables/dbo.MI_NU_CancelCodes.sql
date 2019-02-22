CREATE TABLE [dbo].[MI_NU_CancelCodes]
(
[Code] [int] NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MI_NU_CancelCodes] ADD CONSTRAINT [PK_MI_NU_CancelCodes] PRIMARY KEY CLUSTERED  ([Code]) ON [PRIMARY]
GO
