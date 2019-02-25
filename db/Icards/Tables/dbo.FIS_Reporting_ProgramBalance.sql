CREATE TABLE [dbo].[FIS_Reporting_ProgramBalance]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[INSTCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURRCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PROGRAMID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUMACCS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCNO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCTYPE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FINAMT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLKAMT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AMTAVL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUMCRDS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CARDID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIMARY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRDPRODUCT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRDCUSTCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRDSTATCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPDATE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_FIS_Reporting_ProgramBalance_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FIS_Reporting_ProgramBalance] ADD CONSTRAINT [PK_FIS_Reporting_ProgramBalance] PRIMARY KEY CLUSTERED  ([ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
