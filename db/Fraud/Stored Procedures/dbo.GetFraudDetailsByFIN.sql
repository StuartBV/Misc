SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetFraudDetailsByFIN]
@FIN varchar(10)
as
set nocount on
set transaction isolation level read uncommitted

select f.FIN,cl.ClaimID,f.currenttier,cu.lname+', '+cu.Title+' '+left(cu.fname,1) customer,cu.Postcode,
'Tier '+cast(f.CurrentTier as varchar) tier,s.[description] [status],isnull(b.bookedfor,'') agent,
cast(cl.ClaimID as varchar)+' - '+cu.lname+', '+cu.Title+' '+left(cu.fname,1) +' - ' +cu.Postcode listname, f.[status] FraudStatus, convert(varchar(12),f.CreateDate,13) createdate
,datediff(day, f.createdate, getdate()) as TotalDays
,datediff(day, x.transdate, getdate()) as SubDays
,cl.channel,cl.claimNo
from fraud f join claims cl on f.ClaimID = cl.ClaimID
left join bookings b on b.bookingid=f.bookingid
join Customers cu on cu.ID=cl.CustID
join sysLookup s on s.code=f.[status] and s.TableName='FraudStatus'
left join (
	select fl.fin,fl.bookingid,fl.tierstage,max(fl.transdate) transdate
	from FraudLog fl join fraud fr on fr.fin=fl.fin and fr.bookingid=fl.bookingid and fr.currenttier=fl.tierstage and fr.DateClosed is null
	group by fl.fin,fl.bookingid,fl.tierstage
) as x 
on f.fin=x.fin and f.bookingid=x.bookingid and f.currenttier=x.tierstage
where f.FIN=@FIN	
--unique values to be used for [status] filter
select 1 seq,'All' [description],'All' [status]
union all
select distinct 2 seq,s.[description],s.code [status]
from fraud f 
left join bookings b on b.bookingid=f.bookingid and b.contactmade is null
join sysLookup s on s.code=f.[status] and s.TableName='FraudStatus'
where f.FIN=@FIN	
order by seq,status
--unique values to be used for Tier filter
select 1 seq,'All' [description],'All' tier
union all
select distinct 2 seq,'Tier '+cast(f.currenttier as varchar) [description],cast(f.currenttier as varchar) tier
from fraud f 
left join bookings b on b.bookingid=f.bookingid and b.contactmade is null
join sysLookup s on s.code=f.[status] and s.TableName='FraudStatus'
where f.FIN=@FIN	
order by seq,tier
--fraud members to be used for agent filter
select 1 seq,'All' name,'All' userid,0 roleid,'' [description]
union all
select 2 seq,e.fname+' '+sname NAME,l.userid,r.roleid,s.[description]
from fraud f join claims cl on f.ClaimID = cl.ClaimID
join bookings b on b.bookingid=f.bookingid
join ppd3.dbo.logon l on l.userid=b.bookedfor
join ppd3.dbo.UserRoles r on r.userfk=l.userfk
join ppd3.dbo.syslookup s on s.code=r.roleid and s.tablename='userrole'
join ppd3.dbo.employees e on e.id=l.userfk
where r.RoleID in (1,2) and f.FIN=@FIN

select 1 seq,'All' [description],'All' channel
union all
select distinct 2 seq, c.channel [description], c.channel channel
from fraud f 
left join bookings b on b.bookingid=f.bookingid and b.contactmade is null
join claims c on c.claimid=f.claimid
where f.FIN=@FIN
order by seq,channel

GO
