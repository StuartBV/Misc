CREATE TABLE [dbo].[Cards]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CustomerId] [int] NULL,
[NameOnCard] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardType] [int] NULL,
[CardOnHold] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAN] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Cards_PAN] DEFAULT (''),
[SupplierCardId] [bigint] NULL CONSTRAINT [DF_Cards_SupplierCardId] DEFAULT ((0)),
[Reissue] [bit] NULL CONSTRAINT [DF_Cards_Reissue] DEFAULT ((0)),
[OriginalRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierCode] [tinyint] NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Cards_CreateDate] DEFAULT (getdate()),
[CreatedBy] [dbo].[UserID] NOT NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cards] ADD CONSTRAINT [PK_Cards] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_df_custid] ON [dbo].[Cards] ([CustomerId]) ON [PRIMARY]
GO
