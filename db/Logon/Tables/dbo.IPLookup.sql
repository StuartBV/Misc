CREATE TABLE [dbo].[IPLookup]
(
[ClientID] [int] NOT NULL,
[IPAddress] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IPExpires] [datetime] NULL CONSTRAINT [DF_IPLookup_IPexpires] DEFAULT ('20500101'),
[CreateDate] [smalldatetime] NOT NULL CONSTRAINT [DF_IPLookup_CreateDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [smalldatetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IPLookup] ADD CONSTRAINT [PK_IPLookup] PRIMARY KEY CLUSTERED  ([ClientID], [IPAddress]) ON [PRIMARY]
GO
