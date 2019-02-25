CREATE TABLE [dbo].[iCardsRewardCardLOAD]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClaimID] [int] NULL,
[policyno] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[title] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[initials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[town] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[county] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[postcode] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[processed] [bit] NULL,
[amount] [smallmoney] NULL
) ON [PRIMARY]
GO
