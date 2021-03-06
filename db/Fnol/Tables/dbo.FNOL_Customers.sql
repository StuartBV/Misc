CREATE TABLE [dbo].[FNOL_Customers]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Title] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATregistered] [tinyint] NULL,
[Address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Town] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hphone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Wphone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mphone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[otherinfo] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondFname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondLname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondWPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondMPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondTitle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FNOL_Customers] ADD CONSTRAINT [PK_FNOL_Customers] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_surname] ON [dbo].[FNOL_Customers] ([Lname]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_pcode] ON [dbo].[FNOL_Customers] ([Postcode]) ON [PRIMARY]
GO
