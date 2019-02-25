CREATE TABLE [dbo].[TysisReissueFIS]
(
[PROGRAM_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USER_ID] [float] NULL,
[EXT_LOGIN_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNT_CREATION_DT] [datetime] NULL,
[INITIAL_LOAD] [float] NULL,
[BALANCE] [float] NULL,
[LEDGER_BALANCE] [float] NULL,
[CARD_ISSUE_DT] [datetime] NULL,
[CARD_EXP_DT] [datetime] NULL,
[CARD_STATUS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_TRANSACTION_DATE] [datetime] NULL,
[AvivaRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cash Settled] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[F14] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
