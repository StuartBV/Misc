CREATE TABLE [dbo].[Serilog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Message] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageTemplate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Level] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeStamp] [datetime] NOT NULL,
[Exception] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Properties] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThreadId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Portal] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IpAddress] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Username] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Url] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MachineName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Environment] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Serilog] ADD CONSTRAINT [PK_Serilog] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
