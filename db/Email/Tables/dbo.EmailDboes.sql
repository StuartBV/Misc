CREATE TABLE [dbo].[EmailDboes]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ToEmail] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Body] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Retries] [int] NOT NULL,
[FromEmail] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailDboes] ADD CONSTRAINT [PK_dbo.EmailDboes] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
