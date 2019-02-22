CREATE TABLE [dbo].[checklist]
(
[Claim Ref] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PolicyNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transdate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Note] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[cheque] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payee] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
