CREATE TABLE [dbo].[ClaimProducts]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[claimid] [int] NOT NULL,
[catid] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[make] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[model] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[age] [real] NULL,
[value] [smallmoney] NULL,
[Instruction] [int] NULL,
[limit] [smallmoney] NULL,
[specificvalue] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[createdby] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[createdate] [datetime] NULL,
[alteredby] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[altereddate] [datetime] NULL,
[deleted] [tinyint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClaimProducts] ADD CONSTRAINT [PK_ClaimProducts] PRIMARY KEY CLUSTERED  ([claimid], [ID]) ON [PRIMARY]
GO
