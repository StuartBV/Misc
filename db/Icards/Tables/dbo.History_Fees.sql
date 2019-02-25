CREATE TABLE [dbo].[History_Fees]
(
[TransactionID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionTypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeeID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeeDescription] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeeType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeeValueMode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[TransactionDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CancellationID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyCode] [int] NULL,
[Currency] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentProgramID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentProgramName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
