CREATE TABLE [dbo].[FISDailyExportLoad]
(
[RECTYPE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCALDATE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCALTIME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEMID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MSGID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INSTCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CARDID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRDPRODUCT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PROGRAMID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BRNCODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURBILL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCCUR] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCNO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCTYPE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AMTBILL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CORTEXDATE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRDACPTID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REV] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORGITEMID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESCRIPTION] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOADSRC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOADTYPE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TOTITEMS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
