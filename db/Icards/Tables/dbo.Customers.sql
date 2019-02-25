CREATE TABLE [dbo].[Customers]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[iCardsID] [int] NOT NULL,
[CompanyID] [int] NULL,
[Title] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Town] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_customers_Country] DEFAULT ('UK'),
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Customers_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfBirth] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customers] ADD CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED  ([iCardsID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_ID] ON [dbo].[Customers] ([ID]) INCLUDE ([iCardsID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_lname] ON [dbo].[Customers] ([LastName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_pcode] ON [dbo].[Customers] ([PostCode]) ON [PRIMARY]
GO
