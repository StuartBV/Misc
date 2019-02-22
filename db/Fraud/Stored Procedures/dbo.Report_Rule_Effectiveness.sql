SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Report_Rule_Effectiveness]
@from varchar(20),
@to varchar(20)
as

set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime, @total_received int
select @fd=cast(@from as datetime) + '00:00', @td=cast(@to as datetime) + '23:59:59'

create table #sf_log(indicator int,received int,closed int,reasonclosed varchar(20), value money)
create table #br_log(channel varchar(20),businessrule varchar(200),received int,closed int,reasonclosed varchar(20), value money)
create table #cat_log(channel varchar(20),category varchar(50),received int,closed int,reasonclosed varchar(20), value money)

/*get claims raised by SF indicators*/
insert into #sf_log(indicator ,received ,closed ,reasonclosed, value)
select isnull(nullif(cp.FraudIndicator,''),'0'),
sum(case when f.CreateDate between @fd and @td then 1 else 0 end),
sum(case when f.DateClosed between @fd and @td then 1 else 0 end),
isnull(f.ReasonClosed,''),
sum(cp.Initial_Reserve)
from fraud f join claims c on f.claimid=c.claimid
join ClaimProperties cp on c.ClaimID=cp.ClaimID
where (f.CreateDate between @fd and @td or f.DateClosed between @fd and @td)
and isnull(cp.FraudIndicator,'') not in ('','0') and f.originatingsys='PPD3'
and not exists (select * from ppd3.dbo.ICE_BusinessRules_Log where claimid=c.OriginClaimID and roletype=3 )
group by isnull(nullif(cp.FraudIndicator,''),'0'),f.ReasonClosed

/*get claims raised by Business Triggers*/
insert into #br_log(channel ,businessrule ,received ,closed ,reasonclosed, value)
select c.channel,l.[description],
sum(case when f.CreateDate between @fd and @td then 1 else 0 end),
sum(case when f.DateClosed between @fd and @td then 1 else 0 end),
isnull(f.ReasonClosed,''),
sum(cp.Initial_Reserve)
from fraud f join claims c on f.claimid=c.claimid
join ClaimProperties cp on c.ClaimID=cp.ClaimID
join ppd3.dbo.ICE_BusinessRules_Log l on l.ClaimID=c.OriginClaimID
where (f.CreateDate between @fd and @td or f.DateClosed between @fd and @td)
and l.RoleType=3 and f.originatingsys='PPD3' and f.[Manual]=0
group by c.channel,l.[description],f.ReasonClosed

/*get claims raised by product category*/
insert into #cat_log(channel ,category ,received ,closed ,reasonclosed, value)
select c.channel,ic.[Name],
sum(case when f.CreateDate between @from and @to then 1 else 0 end),
sum(case when f.DateClosed between @from and @to then 1 else 0 end),
isnull(f.ReasonClosed,''),
sum(cp.Initial_Reserve)
from fraud f join claims c on f.claimid=c.claimid
join ClaimProperties cp on c.ClaimID=cp.ClaimID
join ppd3.dbo.ICE_ClaimProducts ip on c.OriginClaimID=ip.claimid 
join ppd3.dbo.ICE_Categories ic on ip.catid=ic.id
where (f.CreateDate between @from and @to or f.DateClosed between @from and @to)
group by c.channel,ic.[Name],f.ReasonClosed

/*summarise by Business Trigger*/
select @total_received=sum(received) from #br_log where received>0

select distinct l.channel,l.businessrule [Trig],
s.vol, round((cast(s.vol as decimal(9,2))/cast(@total_received as decimal(9,2)))*100,2) [per]
from #br_log l
join (select channel,businessrule,sum(received) [vol] from #br_log where received>0 group by channel,businessrule) s on l.channel=s.channel and l.businessrule=s.businessrule
join (select channel,sum(received) [total] from #br_log where received>0 group by channel)t on l.channel=t.channel
where l.received>0
order by 1,2

/*summarise by Business Trigger and Reason closed*/
select @total_received=sum(received) from #br_log where closed>0

select l.channel,l.businessrule [Trig],
s.vol,i.reasonclosed,i.vol as [RC-vol], 
	case when @total_received=0 then 0 else round((cast(i.vol as decimal(9,2))/cast(@total_received as decimal(9,2)))*100,2) end [per],
sum(value) [value]
from #br_log l
join (select channel,businessrule,sum(closed) [vol] from #br_log where closed>0 group by channel,businessrule) s on l.channel=s.channel and l.businessrule=s.businessrule
join (select channel,businessrule,reasonclosed,sum(closed) [vol] from #br_log where closed>0 group by channel,businessrule,reasonclosed) i on l.channel=i.channel
	and l.businessrule=i.businessrule and l.reasonclosed=i.reasonclosed
where l.closed>0
group by l.channel,l.businessrule,s.vol,i.reasonclosed,i.vol, case when @total_received=0 then 0 else round((cast(i.vol as decimal(9,2))/cast(@total_received as decimal(9,2)))*100,2) end
order by 1,2

/*summarise data by SF indicator*/
select @total_received=sum(received) from #sf_log where received>0

select distinct 'SF '+cast(l.indicator as varchar) [Ind],
s.vol, round((cast(s.vol as decimal(9,2))/cast(@total_received as decimal(9,2)))*100,2) [per]
from #sf_log l
join (select indicator,sum(received) [vol] from #sf_log where received>0 group by indicator) s on l.indicator=s.indicator
where l.received>0
order by 1

/*summarise data by SF indicator and Reason closed*/
select @total_received=sum(received) from #sf_log where closed>0

select 'SF '+cast(l.indicator as varchar) [Ind],
s.vol,i.reasonclosed,i.vol as [RC-vol], 
round((cast(i.vol as decimal(9,2))/cast(case when @total_received=0 then 1 else @total_received end as decimal(9,2)))*100,2) [per],
sum(value) [value]
from #sf_log l
join (select indicator,sum(closed) [vol] from #sf_log where closed>0 group by indicator) s on l.indicator=s.indicator
join (select indicator,reasonclosed,sum(closed) [vol] from #sf_log where closed>0 group by indicator,reasonclosed) i on l.indicator=i.indicator and l.reasonclosed=i.reasonclosed
where l.closed>0
group by 'SF '+cast(l.indicator as varchar), s.vol, i.reasonclosed, i.vol , round((cast(i.vol as decimal(9,2))/cast(case when @total_received=0 then 1 else @total_received end as decimal(9,2)))*100,2)
order by 1,2

--Summaries used to be here 
select @total_received=sum(received) from #cat_log where closed>0

select l.channel,l.category,
s.vol,i.reasonclosed,i.vol as [RC-vol], round((cast(i.vol as decimal(9,2))/cast(@total_received as decimal(9,2)))*100,2) [per],
sum(value) [value]
from #cat_log l
join (select channel,category,sum(closed) [vol] from #cat_log where closed>0 group by channel,category) s on l.channel=s.channel and l.category=s.category
join (select channel,category,reasonclosed,sum(closed) [vol] from #cat_log where closed>0 group by channel,category,reasonclosed) i on l.channel=i.channel and l.category=i.category and l.reasonclosed=i.reasonclosed
where l.closed>0
group by l.channel,l.category,s.vol,i.reasonclosed,i.vol, round((cast(i.vol as decimal(9,2))/cast(@total_received as decimal(9,2)))*100,2)
order by 1,2

drop table #sf_log
drop table #br_log
drop table #cat_log
GO
