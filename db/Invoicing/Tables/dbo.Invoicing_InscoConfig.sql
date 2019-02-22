CREATE TABLE [dbo].[Invoicing_InscoConfig]
(
[InscoID] [int] NOT NULL,
[AccountRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoicing_InscoConfig] ADD CONSTRAINT [PK_Invoicing_InscoConfig] PRIMARY KEY CLUSTERED  ([InscoID]) ON [PRIMARY]
GO
