CREATE TABLE [dbo].[Card_companies]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Company] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contact] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceCo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimNoPrefix] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Card_companies_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[enabled] [tinyint] NULL CONSTRAINT [DF__Card_comp__enabl__100C566E] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Card_companies] ADD CONSTRAINT [PK_Card_companies] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CC1] ON [dbo].[Card_companies] ([ID], [Company], [ClaimNoPrefix]) ON [PRIMARY]
GO
