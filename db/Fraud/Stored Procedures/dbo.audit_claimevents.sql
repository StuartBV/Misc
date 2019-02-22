SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[audit_claimevents]
@claimid int
as

set nocount on
set dateformat dmy
set transaction isolation level read uncommitted

select 1 [sequence], 'claim' [eventtype],l.TransDate [transdate],convert(varchar(12),l.TransDate,103) [date],convert(varchar(5),l.TransDate,108) [time],
case
	when l.ActionTaken=0 then 'Status changed'
	when l.ActionTaken=1 then 'Passed to TS Dept'
	when l.ActionTaken=2 then 'Appointment made with Policy Holder'
else s2.[Description] end [event],
case
	when l.ActionTaken=0 then 'Status changed to: '+s1.[Description]+' by '+e.Fname+' '+e.Sname
	when l.ActionTaken=1 then 'Passed to TS Dept by '+e.Fname+' '+e.Sname
	when l.ActionTaken=2 then 'Appointment made with Policy Holder'+' for '+e.Fname+' '+e.Sname
else s2.[Description]+' by '+e.Fname+' '+e.Sname
end [eventdata]
from FraudLog l join fraud f on l.FIN = f.FIN
join sysLookup s1 on l.[status]=s1.code and s1.tablename='FraudStatus'
join sysLookup s2 on l.actiontaken=s2.code and s2.tablename='actiontaken'
join ppd3.dbo.logon pl on pl.userid=l.UserId
join ppd3.dbo.Employees e on e.id=pl.UserFK
where f.ClaimID=@claimid and l.ActionTaken not in (98)

union all

select 2 [sequence], case when n.CreatedBy='sys' then 'System Note' else 'Handler Note' end eventtype, n.CreateDate transdate,
convert(varchar(12),n.CreateDate,103) [date],
convert(varchar(5),n.CreateDate,108) [time],
case when n.CreatedBy='sys' then 'System Note added' else 'Handler Note added by '+e.Fname+' '+e.Sname end + ' ( view )' [event],
replace(note,char(10),'<br>') [eventdata]
from ppd3.dbo.notes n join claims c on c.OriginClaimID=n.claimid
join fraud f on f.ClaimID=c.ClaimID and f.OriginatingSys='ppd3'
left join ppd3.dbo.logon pl on pl.userid=n.CreatedBy
left join ppd3.dbo.Employees e on e.id=pl.UserFK
where f.claimid=@claimid

union all

select 2 [sequence], case when n.CreatedBy='sys' then 'System Note added' else 'Handler Note' end eventtype, n.CreateDate transdate,
convert(varchar(12),n.CreateDate,103) [date], convert(varchar(5),n.CreateDate,108) [time],
case when n.CreatedBy='sys' then 'System Note' else 'Handler Note added by '+e.Fname+' '+e.Sname end + ' ( view )' [event],
replace(cast(note as varchar(8000)),char(10),'<br>') [eventdata]
from fnol.dbo.fnol_notes n join claims c on c.OriginClaimID=n.claimid
join fraud f on f.ClaimID=c.ClaimID and f.OriginatingSys='fnol'
left join ppd3.dbo.logon pl on pl.userid=n.CreatedBy
left join ppd3.dbo.Employees e on e.id=pl.UserFK
where f.claimid=@claimid
and n.CreatedBy<>'sys'

union all

select 3 [sequence], 'cancellation' [eventtype], cast( convert(varchar(12),b.DeletedDate,103)+' '+convert(varchar(5),b.DeletedDate,108)  as datetime) transdate,
convert(varchar(12),b.DeletedDate,103) [date],
convert(varchar(5),b.DeletedDate,108) [time],
'Appointment Cancelled' [event],
'Appontment cancelled by '+' by '+e.Fname+' '+e.Sname
from bookings b join fraud f on b.FIN = f.FIN and b.DeletedDate is not null
join ppd3.dbo.logon pl on pl.userid=b.DeletedBy
join ppd3.dbo.Employees e on e.id=pl.UserFK
where f.ClaimID=@claimid
order by transdate
GO
