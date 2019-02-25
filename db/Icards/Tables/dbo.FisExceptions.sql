CREATE TABLE [dbo].[FisExceptions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RECID] [int] NOT NULL,
[ErrorMessage] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardID] [int] NULL,
[Actioned] [tinyint] NOT NULL CONSTRAINT [DF__FisExcept__Actio__0E240DFC] DEFAULT ((0)),
[CreatedBy] [dbo].[UserID] NULL,
[CreatedDate] [smalldatetime] NULL CONSTRAINT [DF_FisExceptions_CreatedDate] DEFAULT (getdate()),
[AlteredBy] [dbo].[UserID] NULL,
[AlteredDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FisExceptions] ADD CONSTRAINT [PK_FisExceptions] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
