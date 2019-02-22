CREATE TABLE [dbo].[AUTOFNOL_Addresses]
(
[AddressID] [int] NOT NULL IDENTITY(1, 1),
[CustID] [int] NOT NULL,
[LossAdjusterID] [int] NULL,
[Type] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Town] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_AUTOFNOL_Addresses_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AUTOFNOL_Addresses] ADD CONSTRAINT [PK_AUTOFNOL_addresses] PRIMARY KEY CLUSTERED  ([AddressID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_CustID] ON [dbo].[AUTOFNOL_Addresses] ([CustID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
