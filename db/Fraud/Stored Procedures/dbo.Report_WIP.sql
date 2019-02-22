SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Report_WIP]
@from varchar(10),
@to varchar(10)
AS

set QUOTED_IDENTIFIER OFF

set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

create table #fraud_wip_report (tier smallint,[status] varchar(50),total int,weekstart smalldatetime,[week] smallint)

insert into #fraud_wip_report(tier,[status],total,weekstart,[week])
select 
t.Tier [tier],
w.[status],
w.[total],
w.[weekstart],
w.[week]
from (
select 1 tier,'fraudstatus' [tablename]
union
select 2 tier,'fraudstatus' [tablename]
union
select 3 tier,'fraudstatus' [tablename]
) t 
join wip_report w with (nolock) on t.tier=w.tier
where w.weekstart between @fd and @td

declare @sql varchar(8000),@currweek1 smalldatetime,@currweek2 smalldatetime,@currweek3 smalldatetime,@maxweek smalldatetime

select @currweek1=min([weekstart]),@currweek2=min([weekstart]),@currweek3=min([weekstart]),@maxweek=max([weekstart]) from #fraud_wip_report

select weekstart,count(*) [total received],
sum(case when status='closed' then total else 0 end) [total closed],
sum(case when status!='closed' then total else 0 end) [total open],
sum(case when status!='closed' and tier=1 then total else 0 end) [open t1],
sum(case when status!='closed' and tier=2 then total else 0 end) [open t2],
sum(case when status!='closed' and tier=3 then total else 0 end) [open t3]
from #fraud_wip_report
group by weekstart


set @sql="select tier, status"
while (@currweek2<=@maxweek)
  begin
	set @sql=@sql+",isnull(sum(["+convert(varchar(10),@currweek2,103)+"]),0) as ["+convert(varchar(10),@currweek2,103)+"]"
	set @currweek2=dateadd(day,7,@currweek2)
  end
set @sql=@sql+" from (select tier,status"
while (@currweek1<=@maxweek)
  begin
	set @sql=@sql+",case when [weekstart]='"+convert(varchar(10),@currweek1,103)+"' then isnull(sum(total),0) end as ["+convert(varchar(10),@currweek1,103)+"]"
	set @currweek1=dateadd(day,7,@currweek1)
  end
set @sql=@sql+" from #fraud_wip_report w 
where status<>'closed' 
group by tier,status,weekstart) x
group by tier,status
order by tier,status"

exec (@sql)

--print @sql

drop table #fraud_wip_report



GO
