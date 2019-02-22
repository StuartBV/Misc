CREATE TABLE [dbo].[OfficeDetails]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OfficeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TeamName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FaxNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LetterFooter] [tinyint] NULL,
[HubName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Town] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OfficeDetails] ADD CONSTRAINT [PK_OfficeDetails] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
