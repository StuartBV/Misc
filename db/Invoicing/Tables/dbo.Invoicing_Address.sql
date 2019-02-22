CREATE TABLE [dbo].[Invoicing_Address]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[OrderId] [int] NULL,
[DeliveryId] [int] NULL,
[Address1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Town] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactTel] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__INVOICING__Creat__0AD2A005] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoicing_Address] ADD CONSTRAINT [PK_INVOICING_Address] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
