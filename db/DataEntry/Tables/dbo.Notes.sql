CREATE TABLE [dbo].[Notes]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Claim_Id] [int] NOT NULL,
[Text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Notes] ADD CONSTRAINT [PK_dbo.Notes] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Claim_Id] ON [dbo].[Notes] ([Claim_Id]) ON [PRIMARY]
GO
