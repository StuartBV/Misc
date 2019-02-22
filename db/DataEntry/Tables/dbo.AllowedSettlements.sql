CREATE TABLE [dbo].[AllowedSettlements]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[CmsId] [int] NOT NULL,
[Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Claim_Id] [int] NOT NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_AllowedSettlements_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AllowedSettlements] ADD CONSTRAINT [PK_dbo.AllowedSettlements] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Claim_Id] ON [dbo].[AllowedSettlements] ([Claim_Id]) ON [PRIMARY]
GO
