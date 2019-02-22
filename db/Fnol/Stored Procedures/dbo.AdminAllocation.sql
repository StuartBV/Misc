SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AdminAllocation] 
@userid UserID,
@ViewAllReminders tinyint=0
as
set transaction isolation level read uncommitted
set nocount on
set dateformat dmy

declare @dt datetime=getdate()
create table #reminders (reminderid int, claimid int,policyno varchar(50), clientrefno varchar(15), remindertype varchar(50),
duedate varchar(12),duetime varchar(5),daysleft int,[28daylettersent] varchar(10), customer varchar(50), handler varchar(50),
userid UserID, assignedto varchar(50), handlerinclaim varchar(50), email varchar(200), listtype varchar(50) )

insert into #reminders ( reminderid, claimid, policyno, clientrefno, remindertype, duedate, duetime, daysleft,[28daylettersent], customer, handler, userid, assignedto, handlerinclaim, email, listtype )

select distinct c.claimid, c.claimid,p.PolicyNo,ClientRefNo,rt.[description] ReminderType,
convert(varchar(12),@dt,13) duedate, '00:00' duetime,
isnull(datediff(d,convert(varchar(12),@dt,13),convert(varchar(12),c.diaryeventdate,13) ),'0') daysleft,
case when c.[28daylettersent] is not null then 'SENT' else '' end [28daylettersent],
c.Title+' '+c.Fname+' '+c.sname customer,
ln.fullname handler, c.ClaimHandler userid, c.ClaimHandler assignedto,
isnull(c.HandlerInClaim,'') handlerinuse, c.Email, 'allocation' as listtype
from fnol_claims c join Fnol_Policy p on c.PolicyID=p.ID
join ReminderTypes rt on rt.code=c.[status]
left join ppd3.dbo.LogonNames ln on c.ClaimHandler=ln.userid
where c.DateFinalised is null
and (c.ClaimHandler=case when @ViewAllReminders=0 then @userid else c.ClaimHandler end or rt.PrimaryReminder=1)
	
select * from #reminders

--unique values to be used for [status] filter
select 1 seq,'Show All' [description],'All' [status]
union all
select seq,[description]+' ('+cast(total as varchar)+')' as [description],[description] [status]
from (
	select 2 seq, r.remindertype [description], count(distinct r.reminderid) total
	from #reminders r		
	group by r.remindertype
)x
order by seq,[description]

--unique values to be used for [status] filter
select 1 seq,'Show All' [description],'All' [status]
union all
select distinct 2 seq, r.handler [description],r.assignedto code 		
from #reminders r		
order by seq,[description]

drop table #reminders


GO
