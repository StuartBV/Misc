CREATE TABLE [dbo].[Bookings]
(
[BookingID] [int] NOT NULL IDENTITY(1, 1),
[FIN] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BookedFor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[ContactPlace] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactMade] [smallint] NULL,
[NoContactReason] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeletedDate] [datetime] NULL,
[ContactAttempts] [smallint] NULL CONSTRAINT [DF_Bookings_ContactAttempts] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bookings] ADD CONSTRAINT [PK_Bookings] PRIMARY KEY CLUSTERED  ([BookingID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreateDate] ON [dbo].[Bookings] ([CreateDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_DeletedDate] ON [dbo].[Bookings] ([DeletedDate], [StartDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Fin] ON [dbo].[Bookings] ([FIN]) INCLUDE ([BookedFor], [DeletedDate], [StartDate]) ON [PRIMARY]
GO
