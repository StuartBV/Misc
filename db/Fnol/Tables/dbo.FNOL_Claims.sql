CREATE TABLE [dbo].[FNOL_Claims]
(
[ClaimID] [int] NOT NULL IDENTITY(540000, 1),
[PolicyID] [int] NULL,
[CompanyID] [int] NULL,
[ClientRefNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IncidentDate] [datetime] NULL,
[AccountYear] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimHandler] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postcode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hphone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Wphone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mphone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaritalStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rank] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Regiment] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[CoverType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryOfLoss] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LaptopInvolved] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoliceStation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PoliceAddress] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrimeRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateNotified] [datetime] NULL,
[Cause] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Outcome] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateFinalised] [datetime] NULL,
[DateReopened] [datetime] NULL,
[C_Address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_Address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_County] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_Postcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contactname2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactPhone2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Estimate] [money] NULL CONSTRAINT [DF_FNOL_Claims_Estimate] DEFAULT ((0)),
[Reserve] AS ([dbo].[reservesum]([Claimid])),
[Recovery] [money] NULL CONSTRAINT [DF_FNOL_Claims_Recovery] DEFAULT ((0)),
[Total_Amount] AS ([dbo].[PaymentsSum]([ClaimID],'Payment',(0))),
[Total_Cost] AS ([dbo].[PaymentsSum]([ClaimID],'Payment',(0))),
[Total_Recovery] AS ([dbo].[PaymentsSum]([ClaimID],'Recovery',(0))),
[Final_Cost] AS ([dbo].[PaymentsSum]([ClaimID],'Total',(1))),
[DiaryEventDate] [datetime] NULL,
[LossAdjuster] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WizardInputStatus] [tinyint] NULL,
[firstcontactemailed] [datetime] NULL,
[28daylettersent] [datetime] NULL,
[ExcessMethod] [int] NULL,
[Excess] [money] NULL,
[CmsRef] [int] NULL,
[HandlerInClaim] [dbo].[UserID] NULL,
[CreatedDate] [datetime] NULL,
[CreatedBy] [dbo].[UserID] NULL,
[AlteredDate] [datetime] NULL,
[AlteredBy] [dbo].[UserID] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,Derek Francis>
-- Create date: <Create Date, 10-12-2009>
-- Description:	<Description, used to populate the clientrefno field>
-- =============================================
CREATE TRIGGER [dbo].[accountyear]
   ON  [dbo].[FNOL_Claims]
   AFTER update
as

if update(incidentdate) 
BEGIN
	
	SET NOCOUNT ON
	
	update c
	set c.AccountYear=year(i.incidentdate)
	from inserted i 
	join fnol_claims c on i.claimid=c.claimid	    

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[ClaimReopen] ON [dbo].[FNOL_Claims] 
FOR UPDATE 
AS

declare 
@now datetime,
@status varchar(20),
@claimid int,
@for varchar(50),
@type varchar(20),
@date varchar(12),
@time varchar(6),
@note varchar(200),
@userid varchar(50),
@addreminder tinyint=0
		    
set @now=getdate()

if update(status)
begin
	-- Reset finalised date when re-open claim
	update c
	set c.datefinalised=null, c.datereopened=getdate()
	from inserted i 
	join fnol_claims c on i.claimid=c.claimid
	where i.status='REOPENED'
	
	-- existing code for Update Diary Event Date based on status code
	update c
	set c.DiaryEventDate=case when dc.id is null then null else dateadd(dd,dc.flags,@now) end
	from inserted i 
	join fnol_claims c on i.claimid=c.claimid
	left join diarycodes dc on dc.code=i.status
	
	-- Create Reminder on claim based on status code
	select @status=i.status,@claimid=i.claimid, @userid=i.claimhandler
	from inserted i 
	join fnol_claims c on i.claimid=c.claimid
	
	if(@status='RELTOFNOL')
	begin 
		select @for=@userid,
		@note='Claim Released from TS',
		@date=convert(varchar(12),getdate(),103),
		@time='00:00',
		@type='RELTOFNOL',
		@addreminder=1
	end
	
	if(@status='FPAY')
	begin 
		select @for='Manager',
		@note='Failed BACS Payment',
		@date=convert(varchar(12),getdate(),103),
		@time='00:00',
		@type='FPAY',
		@addreminder=1
	end
	
	if(@status='NEW')
	begin 
		select @for='Manager',
		@note='New Claim Created',
		@date=convert(varchar(12),getdate(),103),
		@time='00:00',
		@type='NEW',
		@addreminder=1
	end	
	
	if(@addreminder=1)
	begin 
		exec dbo.AddReminder 
			@claimid = @claimid,
		    @for = @for,
		    @type = @type,
		    @date = @date,
		    @time = @time,
		    @note = @note,
		    @UserID = @userid
	end
	
	
end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,Derek Francis>
-- Create date: <Create Date, 10-12-2009>
-- Description:	<Description, used to populate the clientrefno field>
-- =============================================
CREATE TRIGGER [dbo].[clientrefno]
   ON  [dbo].[FNOL_Claims]
   AFTER INSERT
AS 
BEGIN
	
	SET NOCOUNT ON
	
	update c
	set c.clientrefno='AF'+cast(c.ClaimID as varchar)
	from inserted i 
	join fnol_claims c on i.claimid=c.claimid	    

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[RecoveryReminder] ON [dbo].[FNOL_Claims] 
after UPDATE 
AS

declare 
@now varchar(50), 
@originalrecovery money,
@userid varchar(50),
@claimnote varchar(200),
@claimid int

set @now=convert(varchar(10),getdate(),103)

if update(Recovery)
begin
	select @originalrecovery=d.Recovery,
	@claimid=c.ClaimID,
	@userid=d.AlteredBy,
	@claimnote='Initial Recovery set'
	from deleted d 
	join fnol_claims c on d.claimid=c.claimid
	
	if(@originalrecovery=0 
	and not exists (
		SELECT * FROM reminders 
		where Claimid=@claimid 
		and type='penrec' 
		and DateCompleted is null
		)
	)
	begin
		exec dbo.AddReminder 
			@claimid = @claimid,
		    @for = @userid,
		    @type = 'PENREC', 
		    @date = @now,
		    @time = '00:00',
		    @note = @claimnote,
		    @UserID = @userid			
	end
end
GO
ALTER TABLE [dbo].[FNOL_Claims] ADD CONSTRAINT [PK_FNOL_Claims] PRIMARY KEY CLUSTERED  ([ClaimID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_claimno] ON [dbo].[FNOL_Claims] ([ClientRefNo]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_company] ON [dbo].[FNOL_Claims] ([CompanyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_CompanyId] ON [dbo].[FNOL_Claims] ([CompanyID]) WITH (FILLFACTOR=99) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_customer] ON [dbo].[FNOL_Claims] ([CompanyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_policy] ON [dbo].[FNOL_Claims] ([PolicyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_serviceno] ON [dbo].[FNOL_Claims] ([ServiceNo]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_Status] ON [dbo].[FNOL_Claims] ([Status], [DiaryEventDate]) ON [PRIMARY]
GO
