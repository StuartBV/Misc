CREATE TABLE [dbo].[MI_NU_LossCodes]
(
[PPReason] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NUReason] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MI_NU_LossCodes] ADD CONSTRAINT [PK_MI_NU_LossCodes] PRIMARY KEY CLUSTERED  ([PPReason], [NUReason]) ON [PRIMARY]
GO
