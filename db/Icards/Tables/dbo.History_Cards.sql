CREATE TABLE [dbo].[History_Cards]
(
[CardID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardNumber] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpiryDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssueDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardName2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlasticsRequired] [int] NULL,
[IssuecardType] [int] NULL,
[IssueCardTypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankBinID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardMaterialID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardIssueID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentProgramID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentProgramName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
