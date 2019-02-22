CREATE TABLE [dbo].[Invoicing_Customer]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[InvoiceId] [int] NULL,
[DeliveryId] [int] NULL,
[Title] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Forename] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Surname] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DaytimePhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EveningPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] AS ((isnull([title]+' ','')+isnull([forename]+' ',''))+isnull([surname],'')),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__INVOICING__Creat__07F6335A] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoicing_Customer] ADD CONSTRAINT [PK_INVOICING_Customer] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
