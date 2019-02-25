CREATE TABLE [dbo].[FISCardAdjustmentsLoad]
(
[RecId] [int] NOT NULL,
[Pan] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CardId] [bigint] NOT NULL,
[Processed] [bit] NOT NULL CONSTRAINT [DF_FISCardAdjustmentsLoad_Processed] DEFAULT ((0)),
[Createdate] [datetime] NOT NULL CONSTRAINT [DF_FISCardAdjustmentsLoad_Createdate] DEFAULT (getdate()),
[AlteredBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FISCardAdjustmentsLoad] ADD CONSTRAINT [PK_FISCardAdjustmentsLoad] PRIMARY KEY CLUSTERED  ([RecId]) ON [PRIMARY]
GO
