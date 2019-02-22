CREATE TABLE [dbo].[userdata]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[ClientID] [int] NOT NULL,
[FName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ISAdmin] [tinyint] NOT NULL CONSTRAINT [DF_UserData_ISAdmin] DEFAULT ((0)),
[LastAuth] [datetime] NULL,
[LastLogin] [datetime] NULL,
[ChangedPW] [datetime] NULL,
[CurrentApplication] [int] NULL,
[CurrentPage] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GlobalLogin] [tinyint] NOT NULL CONSTRAINT [DF_UserData_GlobalLogin] DEFAULT ((0)),
[Hash] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_UserData_Hash] DEFAULT (''),
[Enabled] [tinyint] NOT NULL CONSTRAINT [DF_UserData_Enabled] DEFAULT ((1)),
[Deleted] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_UserData_Deleted] DEFAULT (''),
[IP] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[validator_lockedout] [tinyint] NULL CONSTRAINT [DF_UserData_validator_lockedout] DEFAULT ((0)),
[LastUnlocked] [datetime] NULL,
[FailedLogons] [tinyint] NOT NULL CONSTRAINT [DF_userdata_FailedLogons] DEFAULT ((0)),
[Email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PasswordHistory] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_userdata_PasswordHistory] DEFAULT (''),
[Mobile] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TFAStatus] [tinyint] NOT NULL CONSTRAINT [DF_UserData_TFAStatus] DEFAULT ((0)),
[TFAGenerated] [datetime] NULL,
[TeamName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KeepSignedIn] [bit] NOT NULL CONSTRAINT [DF_userdata_KeepSignedIn] DEFAULT ((0)),
[LastSecurityStatus] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_UserData_CreatedDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupEmail] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[userdata] ADD CONSTRAINT [PK_UserData] PRIMARY KEY CLUSTERED  ([UID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_ClientID] ON [dbo].[userdata] ([ClientID]) INCLUDE ([FName], [SName], [UserName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Hash] ON [dbo].[userdata] ([Hash], [Enabled]) INCLUDE ([ClientID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Lastauth] ON [dbo].[userdata] ([LastAuth], [Deleted]) INCLUDE ([AlteredBy], [Enabled]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Username] ON [dbo].[userdata] ([UserName], [Password], [Enabled], [Deleted]) INCLUDE ([ClientID], [FName], [SName]) ON [PRIMARY]
GO
