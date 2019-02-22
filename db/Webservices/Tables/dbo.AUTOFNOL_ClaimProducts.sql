CREATE TABLE [dbo].[AUTOFNOL_ClaimProducts]
(
[ProductID] [int] NOT NULL IDENTITY(1, 1),
[MessageID] [int] NOT NULL,
[catid] [int] NULL,
[make] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[model] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[age] [real] NULL,
[value] [smallmoney] NULL,
[Instruction] [int] NULL,
[limit] [smallmoney] NULL,
[specificvalue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[createdby] [dbo].[UserID] NULL CONSTRAINT [DF_AUTOFNOL_ClaimProducts_createdby] DEFAULT ('sys'),
[createdate] [datetime] NULL CONSTRAINT [DF_AUTOFNOL_ClaimProducts_createdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AUTOFNOL_ClaimProducts] ADD CONSTRAINT [PK_AUTOFNOL_ClaimProducts] PRIMARY KEY CLUSTERED  ([MessageID], [ProductID]) ON [PRIMARY]
GO
