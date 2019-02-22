CREATE TABLE [dbo].[Bordereau_Export_Log]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[NextBordereauNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BordereauCount] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuranceClaimNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceNumber] [int] NULL,
[AccountRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Total] [money] NULL,
[ValidationFee] [smallmoney] NULL,
[Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SentDate] [datetime] NULL,
[Filename] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PolicyCover] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoValsPerRef] [int] NULL,
[System] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoredProcedure] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Bordereau_Export_Log_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bordereau_Export_Log] ADD CONSTRAINT [PK_Bordereau_Export_Log] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
