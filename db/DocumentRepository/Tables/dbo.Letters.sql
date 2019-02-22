CREATE TABLE [dbo].[Letters]
(
[LID] [int] NOT NULL IDENTITY(1, 1),
[claimId] [int] NOT NULL,
[FK_ID] [int] NOT NULL CONSTRAINT [DF_Letters_FK_ID] DEFAULT ((0)),
[letterType] [tinyint] NOT NULL,
[letterFormat] [tinyint] NOT NULL,
[letterData] [image] NOT NULL,
[createDate] [datetime] NOT NULL CONSTRAINT [DF_CustomerLetters_createDate] DEFAULT (getdate()),
[printDate] [datetime] NULL CONSTRAINT [DF_Letters_printDate] DEFAULT (NULL),
[LetterText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[PrintedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Letters] ADD CONSTRAINT [PK_CustomerLetters] PRIMARY KEY CLUSTERED  ([LID]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_ClaimID] ON [dbo].[Letters] ([claimId], [letterType]) INCLUDE ([createDate], [FK_ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_CreateDate] ON [dbo].[Letters] ([createDate]) WITH (FILLFACTOR=100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_LetterType] ON [dbo].[Letters] ([letterType], [printDate]) INCLUDE ([claimId]) ON [PRIMARY]
GO
