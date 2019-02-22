SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetSearchResults]
@searchfor varchar(100)='',
@searchby varchar(50)='',
@tier varchar(2)='',
@status varchar(5)='',
@agent varchar(50)='',
@channel varchar(50)='',
@risk varchar(2)='',
@page smallint=1, -- Page to list
@pagesize smallint=22 -- Items per page
as
set nocount on
set transaction isolation level read uncommitted

declare @start smallint,@end smallint,@MaxReviewChars int,@sectionID smallint,@sql varchar(8000)

set @start=(@page*@pagesize)-@pagesize+1
set @end=@page*@pagesize
set @sql=""

create table #tmp (idnum int identity(1,1)primary key, FIN varchar(20),ClaimID int,currenttier int,customer varchar(100),Postcode varchar(15),tier varchar(10),
status varchar(50),agent varchar(50),listname varchar(100),FraudStatus int,createdate varchar(15), TotalDays int,SubDays int,channel varchar(20),claimNo varchar(20),reminder varchar(10), risk int )

create table #tmp2 (idnum int identity(1,1)primary key, FIN varchar(20),ClaimID int,currenttier int,customer varchar(100),Postcode varchar(15),tier varchar(10),
status varchar(50),agent varchar(50),listname varchar(100),FraudStatus int,createdate varchar(15), TotalDays int,SubDays int,channel varchar(20),claimNo varchar(20),reminder varchar(10), risk int )

set @sql="insert into #tmp2(FIN,ClaimID,currenttier,customer,Postcode,tier,status,agent,listname,FraudStatus,createdate,TotalDays,SubDays,channel,claimNo,reminder,risk) 
select f.FIN,cl.ClaimID,f.currenttier,cu.lname+', '+cu.Title+' '+left(cu.fname,1) customer,cu.Postcode,
'Tier '+cast(f.CurrentTier as varchar) tier,s.description status,
isnull(f.ClaimHandler,'UnAssigned') agent,
cast(cl.ClaimID as varchar)+' - '+cu.lname+', '+cu.Title+' '+left(cu.fname,1) +' - ' +cu.Postcode listname, f.status FraudStatus, convert(varchar(12),f.CreateDate,13) createdate
,datediff(day, f.createdate, coalesce(f.dateclosed,getdate())) as TotalDays
,datediff(day, x.transdate, getdate()) as SubDays
,cl.channel,cl.claimNo,
case when datediff(d,convert(varchar(12),getdate(),13),convert(varchar(12),f.diaryeventdate,13) )<=0 then 'remind' else '' end reminder, f.risk
from fraud f with (nolock) join claims cl with (nolock) on f.ClaimID = cl.ClaimID
join Customers cu with (nolock) on cu.ID=cl.CustID
join sysLookup s with (nolock) on s.code=f.status and s.TableName='FraudStatus'
left join (
	select fl.fin,max(fl.transdate) transdate
	from FraudLog fl join fraud fr on fr.fin=fl.fin and fr.DateClosed is null
	and fl.actiontaken=0
	group by fl.fin
) as x 
on f.fin=x.fin
where 1=1 "

if(@searchfor='' and @status<>'99')
 begin
 	set @sql=@sql+"and f.DateClosed is null "
 end
else if(@searchby='claimid')
 begin
	set @sql=@sql+"and cl.claimno='"+@searchfor+"' "
 end
else if(@searchby='fin')
 begin
	set @sql=@sql+"and f.FIN='"+@searchfor+"' "
 end
else if(@searchby='postcode')
 begin
	set @sql=@sql+"and cu.Postcode='"+@searchfor+"' "
 end
else if(@searchby='surname')
 begin
	set @sql=@sql+"and cu.Lname='"+@searchfor+"' "
 end

exec(@sql)

insert into #tmp(FIN,ClaimID,currenttier,customer,Postcode,tier,status,agent,listname,FraudStatus,createdate,TotalDays,SubDays,channel,claimNo,reminder,risk)
select FIN,ClaimID,currenttier,customer,Postcode,tier,status,agent,listname,FraudStatus,createdate,TotalDays,SubDays,channel,claimNo,reminder,risk
from #tmp2
where CurrentTier=case when @tier='' then CurrentTier else @tier end
and FraudStatus=case when @status='' then FraudStatus else @status end
and agent=case when @agent='' then agent else @agent end
and Channel=case when @channel='' then Channel else @channel end
and risk=case when @risk='' then risk else @risk end
order by 13 desc

select * from #tmp where idnum between @start and @end

--unique values to be used for status filter
select 1 seq,'All' description,'All' status
union all
select distinct 2 seq,s.description,s.code status
from sysLookup s where s.TableName='FraudStatus'
order by 1,2

--unique values to be used for Tier filter
select 1 seq,'All' description,'All' tier
union all
select distinct 2 seq,'Tier '+cast(t.currenttier as varchar) description,cast(t.currenttier as varchar) tier
from #tmp2 t
join sysLookup s on s.code=t.fraudstatus and s.TableName='FraudStatus'
order by seq,tier

--unique values for agents filter
select 1 seq,'All' name,'All' userid
union all
select 2 seq,'unAssigned' name,'unAssigned' userid
union all
select distinct 3 seq,e.fname+' '+sname NAME,u.userid
from #tmp2 t 
join ppd3.dbo.logon l on l.userid=t.agent
join users u on t.agent=u.userid
join ppd3.dbo.employees e on e.id=l.userfk
order by 1,2

--unique values for channels filter
select 1 seq,'All' [description],'All' [channel]
union all
select distinct 2 seq, channel [description], channel [channel]
from #tmp2
order by seq,channel

select coalesce(max(idnum),0) Qty,coalesce(round(max(idnum)/cast(@pagesize as decimal(7,2))+0.49,0),0) Pages from #tmp;

--unique values for risk filter
select 1 seq,'All' description,'All' risk
union all
select distinct 2 seq,Description, code [risk]
from #tmp2 t
join sysLookup s on s.TableName='risk' and s.code=t.risk
order by seq,risk


drop table #tmp
drop table #tmp2

GO
