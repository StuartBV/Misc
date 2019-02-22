CREATE TABLE [dbo].[AUTOFNOL_Customers]
(
[CustID] [int] NOT NULL IDENTITY(1, 1),
[Title] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fname] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lname] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATregistered] [tinyint] NULL,
[Mphone] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Wphone] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[details] [int] NULL,
[PreferredContactMethod] [int] NULL CONSTRAINT [DF_AUTOFNOL_Customers_PreferredContactMethod] DEFAULT ((0)),
[Hphone] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_AUTOFNOL_Customers_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL CONSTRAINT [DF_AUTOFNOL_Customers_CreatedBy] DEFAULT ('sys'),
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AUTOFNOL_Customers] ADD CONSTRAINT [PK_AUTOFNOL_Customers] PRIMARY KEY CLUSTERED  ([CustID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
