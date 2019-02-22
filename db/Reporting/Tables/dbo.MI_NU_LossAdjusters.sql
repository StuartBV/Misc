CREATE TABLE [dbo].[MI_NU_LossAdjusters]
(
[LAID] [int] NOT NULL,
[LaName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MI_NU_LossAdjusters] ADD CONSTRAINT [PK_MI_NU_LossAdjusters] PRIMARY KEY CLUSTERED  ([LAID]) ON [PRIMARY]
GO
