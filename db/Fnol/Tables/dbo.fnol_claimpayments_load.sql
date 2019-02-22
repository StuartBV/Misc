CREATE TABLE [dbo].[fnol_claimpayments_load]
(
[ClaimID] [int] NULL,
[TransDate] [datetime] NULL,
[ChequeNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Payee] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
