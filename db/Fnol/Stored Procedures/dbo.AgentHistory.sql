SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AgentHistory] 
as
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted

declare @now datetime=getdate(), @now3 datetime, @now4 datetime
select @now3=@now-3, @now4=@now-4

create table #history (ID int, document varchar(50),docref varchar(50),customer varchar(255),Postcode varchar(15), 
	agent varchar(50),datechanged datetime, datestr varchar(12),timestr varchar(5))

	insert into #history( ID,document,docref,customer,Postcode,agent,datechanged,datestr,timestr)
	select p.ID ID, 'Policy' [document],	 p.PolicyNo [docref], c.Title+' '+c.Fname+' '+c.lname customer, c.Postcode,
	t.UserID agent, t.[date] [datechanged], convert(varchar(12),t.[date],103) [datestr], convert(varchar(5),t.[date],108) [timestr]
	from UserTracking t join FNOL_Policy p on p.id=t.id join FNOL_Customers c on p.CustomerID=c.ID
	where t.[date]>=@now4 and t.DocType='policy'

	insert into #history(ID,document,docref,customer,Postcode,agent,datechanged,datestr,timestr) 
	select c.ClaimID ID, 'Claim' [document],	 c.ClientRefNo [docref], c.Title+' '+c.Fname+' '+c.sname customer,
c.Postcode, t.UserID agent, t.[date] [datechanged], convert(varchar(12),t.[date],103) [datestr], convert(varchar(5),t.[date],108) [timestr]
	from UserTracking t join FNOL_claims c on c.claimid=t.id 
	where t.[date]>=@now3 and t.DocType='claim'

	select ID, document, docref, customer, Postcode, agent, datechanged, datestr, timestr
	from #history
	order by datechanged desc

	--unique values to be used for agent filter
	select 1 seq,'Show All' [description],'All' agent
	union all
	select seq,[description]+' ('+cast(total as varchar)+')' as [description], agent 
	from (
		select 2 seq, t.agent [description], t.agent, count(*) total
		from #history t
		group by t.agent
	)x

	--unique values to be used for date filter

	select * from (
		select distinct 2 seq, t.datestr [description], t.datestr code
		from #history t
	)x
	order by cast(x.code as datetime) desc

	drop table #history

GO
