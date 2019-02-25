CREATE TABLE [dbo].[cards_testload]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CustomerId] [int] NULL,
[NameOnCard] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardType] [int] NULL,
[CreateDate] [datetime] NOT NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardOnHold] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SupplierCardId] [bigint] NULL
) ON [PRIMARY]
GO
