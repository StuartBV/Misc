SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Load_WIP_Report_Data]
as
set nocount on
set dateformat dmy
declare @fd datetime,@td datetime
select @fd=cast(floor(cast(getdate()-6 as float)) as datetime) + '00:00', @td=cast(floor(cast(getdate() as float)) as datetime) + '23:59:59'
select @fd,@td

insert into wip_report(tier,[status],total,weekstart,[week])
select 
	t.Tier [tier],
	sl.description [status],
	sum(case when f.fin is null then 0 else 1 end) [total],
	convert(varchar(10),DateAdd(day, -1 * datepart(dw, @td),@td ),103) [weekstart],
	datepart(wk,@td) [week]
from (
	select 1 tier
	union
	select 2 tier
	union
	select 3 tier
)t 
join sysLookup sl on sl.tablename='fraudstatus'
left join (
	select f.currenttier, f.status, f.fin
	from fraud f with (nolock) 
	where (f.CreateDate between @fd and @td)
	or f.DateClosed is null
	or (f.DateClosed between @fd and @td)
)f on f.currenttier=t.tier and f.[status]=sl.code
group by t.Tier, sl.description
order by 1, 2











select f.currenttier, f.status, f.fin
from fraud f with (nolock) 
where (f.CreateDate between '20090607' and '20090613 23:59:59')
or (dateclosed is null or dateclosed>='20090614')
GO
