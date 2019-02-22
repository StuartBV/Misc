CREATE TABLE [dbo].[iValBRAD_Complaints]
(
[Source] [tinyint] NULL,
[iVal Ref] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ComplaintID] [int] NOT NULL,
[Insurance Company] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Insurer Claim Ref] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Insurer Policy Ref] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Insurer Branch] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Insured Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type of Complaint] [varchar] (533) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Complaint From] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Complaint Against] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Resolved within 2-5 days] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Resolved within 6-20 days] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Resolved within 20-40 days] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Outcome] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Current Status] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Received] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Acknowledged] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Hold letter issued] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Decision issued] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Reopened/Reclosed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FOS leaflet issued] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FSA closed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[How received] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Referred To] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Compensation Amount] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Escalated] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Last updated] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [smalldatetime] NOT NULL CONSTRAINT [DF_iValBRAD_Complaints_CreateDate] DEFAULT (getdate()),
[RunDay] AS (datepart(day,[createdate])),
[RunMonth] AS (datepart(month,[createdate])),
[RunYear] AS (datepart(year,[createdate]))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iValBRAD_Complaints] ADD CONSTRAINT [PK_iValBRAD_Complaints] PRIMARY KEY CLUSTERED  ([iVal Ref], [ComplaintID], [CreateDate]) ON [PRIMARY]
GO
