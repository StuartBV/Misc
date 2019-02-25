CREATE TABLE [dbo].[EmailErrors]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ErrorDateTime] [datetime] NOT NULL,
[Msg] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Exception] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bus] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Handler] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailErrors] ADD CONSTRAINT [PK_dbo.EmailErrors] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
