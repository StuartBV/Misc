CREATE TABLE [dbo].[SupplierCardLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TransactionID] [int] NOT NULL,
[PAN] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CardID] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CardEvent] [tinyint] NOT NULL,
[ExpiryDate] [smalldatetime] NOT NULL,
[CreatedBy] [dbo].[UserID] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_SupplierCardLog_CreatedDate] DEFAULT (getdate()),
[AlteredBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SupplierCardLog] ADD CONSTRAINT [PK_SupplierCardLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_TransactionID] ON [dbo].[SupplierCardLog] ([TransactionID]) INCLUDE ([CardID], [StatCode]) ON [PRIMARY]
GO
