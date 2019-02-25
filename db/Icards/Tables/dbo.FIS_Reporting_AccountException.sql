CREATE TABLE [dbo].[FIS_Reporting_AccountException]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EXCEPTTYPE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRDEXPDATE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEMID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TLOGID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AMTBILL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURBILLALPHA] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DATELOCAL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[APRVLCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RRN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCNO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AVLBAL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLKAMT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORIGLOADAMT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MAXBAL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INSTCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_FIS_Reporting_AccountException_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FIS_Reporting_AccountException] ADD CONSTRAINT [PK_FIS_Reporting_AccountException] PRIMARY KEY CLUSTERED  ([ID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
