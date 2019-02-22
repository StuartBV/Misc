SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ReminderEvents_summary] 
@userid UserID,
@ViewAllReminders tinyint=0
as
set transaction isolation level read uncommitted
set nocount on
set dateformat dmy

create table #reminders (reminderid int, claimid int,policyno varchar(50), clientrefno varchar(15), remindertype varchar(50),duedate varchar(12),
	duetime varchar(5),daysleft int,[28daylettersent] varchar(10), customer varchar(50), handler varchar(50), userid UserID,
	assignedto varchar(50), handlerinclaim varchar(50), email varchar(200) )

insert into #reminders ( reminderid, claimid, policyno, clientrefno, remindertype, duedate, duetime, daysleft,[28daylettersent], customer, handler, userid, assignedto, handlerinclaim, email )

select distinct r.id, c.claimid,p.PolicyNo,ClientRefNo,rt.[description] [ReminderType],
convert(varchar(12),r.DueDate,13) duedate,
case when convert(varchar(5),r.DueDate,108)='00:00' then '' else convert(varchar(5),r.DueDate,108) end duetime,
isnull(datediff(d,convert(varchar(12),getdate(),13),convert(varchar(12),r.DueDate,13) ),'') daysleft,
case when c.[28daylettersent] is not null then 'SENT' else '' end [28daylettersent],
c.Title+' '+c.Fname+' '+c.sname customer,
case when coalesce(wl.UserId,r.userid)='Manager' then 'FNOL Manager' else coalesce(wln.fullname,ln.fullname) end [handler],
coalesce(wl.UserId,r.userid) [userid], coalesce(wl.UserId,r.userid) assignedto, isnull(c.HandlerInClaim,'') [handlerinuse], c.Email
from reminders r join dbo.ReminderTypes rt on rt.code=r.[type]
left join dbo.WorkToList wl on wl.ReminderType=r.[type]
join fnol_claims c on r.claimid=c.ClaimID
join FNOL_Policy p on c.PolicyID=p.ID
left join ppd3.dbo.LogonNames ln on r.UserId=ln.userid
left join ppd3.dbo.LogonNames wln on wl.UserId=wln.userid
where r.DateCompleted is null
and (
	r.UserId=case when @ViewAllReminders=0 then @userid else r.userid end
	or rt.PrimaryReminder=1
	or (r.[type]=wl.ReminderType and wl.UserId=@userid)
)
union all
select distinct c.claimid, c.claimid,p.PolicyNo,ClientRefNo,rt.[description] [ReminderType],
convert(varchar(12),c.diaryeventdate,13) duedate, '00:00' duetime,
isnull(datediff(d,convert(varchar(12),getdate(),13),convert(varchar(12),c.diaryeventdate,13) ),'') daysleft,
case when c.[28daylettersent] is not null then 'SENT' else '' end [28daylettersent],
c.Title+' '+c.Fname+' '+c.sname customer,
case when wl.UserId='Manager' then 'FNOL Manager' else coalesce(wln.fullname,ln.fullname) end [handler],
wl.UserId, wl.UserId assignedto, isnull(c.HandlerInClaim,'') [handlerinuse], c.Email
from dbo.WorkToList wl join dbo.ReminderTypes rt on rt.code=wl.ReminderType
join fnol_claims c on c.[status]=wl.ReminderType
join FNOL_Policy p on c.PolicyID=p.ID
left join ppd3.dbo.LogonNames ln on ln.userid='derekf'
left join ppd3.dbo.LogonNames wln on wl.UserId=wln.userid
where (wl.UserId=case when @ViewAllReminders=0 then @userid else wl.userid end or rt.PrimaryReminder=1)

select distinct reminderid, claimid, policyno, clientrefno, remindertype, duedate, duetime, daysleft, [28daylettersent], customer, handlerinclaim, email 
from #reminders

--unique values to be used for status filter
select 1 seq,'Show All' [description],'All' [status]
union all
select seq,[description]+' ('+cast(total as varchar)+')' as [description],[description] [status]
from (
	select 2 seq, r.remindertype [description], count(distinct r.reminderid) total
	from #reminders r		
	group by r.remindertype
)x
order by seq,[description]

--unique values to be used for status filter
select 1 seq,'Show All' [description],'All' [status]
union all
select distinct 2 seq, r.handler [description],r.assignedto code 		
from #reminders r		
order by seq,[description]

drop table #reminders
GO
