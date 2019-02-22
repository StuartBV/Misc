SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetOutstandingFraud]
as
set nocount on
set transaction isolation level read uncommitted

--main search results
select f.FIN,cl.ClaimID,f.currenttier,cu.lname+', '+cu.Title+' '+left(cu.fname,1) customer,cu.Postcode,
'Tier '+cast(f.CurrentTier as varchar) tier,s.[description] [status],coalesce(b.bookedfor,f.alteredby,f.createdby) agent,
cast(cl.ClaimID as varchar)+' - '+cu.lname+', '+cu.Title+' '+left(cu.fname,1) +' - ' +cu.Postcode listname, f.[status] FraudStatus, convert(varchar(12),f.CreateDate,13) createdate
,datediff(day, f.createdate, getdate()) as TotalDays
,datediff(day, x.transdate, getdate()) as SubDays
,cl.channel,cl.claimNo
from fraud f join claims cl on f.ClaimID = cl.ClaimID
left join bookings b on b.bookingid=f.bookingid
join Customers cu on cu.ID=cl.CustID
join sysLookup s on s.code=f.[status] and s.TableName='FraudStatus'
left join (
	select fl.fin,max(fl.transdate) transdate
	from FraudLog fl 
	group by fl.fin
) as x 
on f.fin=x.fin
where f.DateClosed is null
order by 10 desc

--unique values to be used for [status] filter
select 1 seq,'All' [description],'All' [status]
union all
select distinct 2 seq,s.[description],s.code [status]
from fraud f 
left join bookings b on b.bookingid=f.bookingid and b.contactmade is null
join sysLookup s on s.code=f.[status] and s.TableName='FraudStatus'
where f.DateClosed is null
order by seq,[status]
--unique values to be used for Tier filter
select 1 seq,'All' [description],'All' tier
union all
select distinct 2 seq,'Tier '+cast(f.currenttier as varchar) [description],cast(f.currenttier as varchar) tier
from fraud f 
left join bookings b on b.bookingid=f.bookingid and b.contactmade is null
join sysLookup s on s.code=f.[status] and s.TableName='FraudStatus'
where f.DateClosed is null
order by seq,tier

select 1 seq,'All' name,'All' userid,0 roleid,'' [description]
union all
select 2 seq,e.fname+' '+sname NAME,l.userid,r.roleid,s.[description]
from ppd3.dbo.syslookup s 
join ppd3.dbo.UserRoles r on s.code=r.roleid and s.tablename='userrole'
join ppd3.dbo.logon l on l.userfk=r.userfk
join ppd3.dbo.employees e on e.id=l.userfk
where r.RoleID in (1,2)

select 1 seq,'All' [description],'All' channel
union all
select distinct 2 seq, c.channel [description], c.channel channel
from fraud f 
left join bookings b on b.bookingid=f.bookingid and b.contactmade is null
join claims c on c.claimid=f.claimid
where f.DateClosed is null
order by seq,channel


GO
