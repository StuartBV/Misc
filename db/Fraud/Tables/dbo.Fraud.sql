CREATE TABLE [dbo].[Fraud]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FIN] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClaimID] [int] NULL,
[BookingID] [int] NULL,
[CurrentTier] [smallint] NULL,
[Status] [smallint] NULL,
[InUse] [smallint] NULL CONSTRAINT [DF_Fraud_InUse] DEFAULT ((0)),
[DiaryEventDate] [smalldatetime] NULL,
[Tier2ReviewStarted] [datetime] NULL,
[Tier2ReviewEnded] [datetime] NULL,
[Tier2InterviewStarted] [datetime] NULL,
[Tier2InterviewEnded] [datetime] NULL,
[Tier3ReviewStarted] [datetime] NULL,
[Tier3ReviewEnded] [datetime] NULL,
[Tier3InterviewStarted] [datetime] NULL,
[Tier3InterviewEnded] [datetime] NULL,
[Risk] [smallint] NULL CONSTRAINT [DF_Fraud_Risk] DEFAULT ((0)),
[DateClosed] [smalldatetime] NULL,
[ReasonClosed] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReasonWithdrawn] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginatingSys] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL,
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimHandler] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReasonClosed_SubCategory] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manual] [tinyint] NULL CONSTRAINT [DF_Fraud_Manual] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[StatusChange] ON [dbo].[Fraud] 
FOR UPDATE 
AS

declare @now datetime
set @now=getdate()

if update(status)
begin
	-- Update Diary Event Date based on status code
	update f
	set f.DiaryEventDate=case when dc.id is null then null else dateadd(dd,dc.flags,@now) end
	from inserted i 
	join fraud f on i.fin=f.fin
	left join remindercodes dc on dc.code=i.status
end
GO
ALTER TABLE [dbo].[Fraud] ADD CONSTRAINT [PK_Fraud] PRIMARY KEY CLUSTERED  ([ID]) WITH (FILLFACTOR=100, PAD_INDEX=ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_booking] ON [dbo].[Fraud] ([BookingID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_claimid] ON [dbo].[Fraud] ([ClaimID], [OriginatingSys]) INCLUDE ([CurrentTier]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_dateclosed] ON [dbo].[Fraud] ([DateClosed]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_fin] ON [dbo].[Fraud] ([FIN]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Reporting] ON [dbo].[Fraud] ([OriginatingSys], [ClaimID], [ReasonClosed], [Status]) ON [PRIMARY]
GO
