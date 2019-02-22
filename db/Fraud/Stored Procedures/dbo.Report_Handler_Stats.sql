SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Report_Handler_Stats]
@handler UserID,
@from varchar(10),
@to varchar(10)
as
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted

declare @fd datetime,@td datetime, @dt datetime=getdate(), @handler_name varchar(50),@handler_team varchar(50),@wip int,@wip_lifecycle int,
	@cases_closed int,@cases_closed_fraud int,@cases_closed_nonfraud int,@perc_fraud_saving decimal(5,1)

select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

declare @sql varchar(8000)='',@graph_data varchar(8000)='', @graph_labels varchar(8000)='', @graph_limit decimal(5,1)

create table #report_tmp (idnum int identity(1,1)primary key,[month] varchar(20),[avg] decimal(5,1))

/*################################################# 
create the stats table data 
##################################################*/

/* get handlers name and team name */
select @handler_name=e.fname+' '+sname, @handler_team=s.[Description]
from Users r join ppd3.dbo.logon l on l.userid=r.userid
join ppd3.dbo.employees e on e.id=l.userfk
join sysLookup s on s.code=r.Team and s.TableName='team'
where r.userid=@handler

/* calculate WIP */
select @wip=count(*) ,@wip_lifecycle=isnull(sum(case when datediff(dd, f.createdate, @dt)>30 then 1 else 0 end),0)
from fraud f 
where f.dateclosed is null and f.ClaimHandler=@handler

/* calculate cases closed stats */
select @cases_closed=count(*), @cases_closed_fraud=isnull(sum(case when f.ReasonClosed in ('PPFW','PPFR','EFW','EFR') then 1 else 0 end),0),
@cases_closed_nonfraud=isnull(sum(case when f.ReasonClosed in ('NFD','INSC','INSW') then 1 else 0 end),0)
from fraud f 
where f.dateclosed between @fd and @td and f.ClaimHandler=@handler

/* calculate percentage saving */
select @perc_fraud_saving=case when @cases_closed=0 then 0 else (cast(@cases_closed_fraud as decimal(5,1)) / cast(@cases_closed as decimal(5,1) )*100) end

/* output first table */
select 'DATA' [report_type],'Stats' [report_title],@handler_name [Handler],@handler_team [Team],@wip [Outst.WIP],@wip_lifecycle [WIP 30+ Days],@cases_closed [Cases Closed],
@cases_closed_nonfraud [Closed as Non-Fraud],@cases_closed_fraud [Closed as Fraud],@perc_fraud_saving [% closed as Fraud Saving]

/*################################################# 
create the fraud savings table data 
##################################################*/

insert into #report_tmp ( [month], [avg] )

select left(datename(mm,'01/'+cast(d.digit as varchar)+'/1900'),3) [month],
	isnull((cast(sum(case when f.ReasonClosed in ('PPFW','PPFR','EFW','EFR') then 1 else 0 end) as decimal(5,1)) / nullif(cast(count(f.DateClosed) as decimal(5,1)),0))*100,0) [avg]
from ppd3.dbo.digits d 
left join fraud f on d.digit=month(f.DateClosed) and f.dateclosed between @fd and @td and f.ClaimHandler=@handler
where d.digit between 1 and 12
group by 
	left(datename(mm,'01/'+cast(d.digit as varchar)+'/1900'),3),
	case when d.digit>month(getdate()) then year(dateadd(yy,-1,getdate())) else year(getdate()) end,
	isnull(month(f.DateClosed),d.digit)
order by 
	case when d.digit>month(getdate()) then year(dateadd(yy,-1,getdate())) else year(getdate()) end,
	isnull(month(f.DateClosed),d.digit)

select @sql=@sql+",'"+cast(avg as varchar)+"' as "+[month] from #report_tmp order by idnum
select @sql="select 'DATA' [report_type], 'Fraud Saving % - Table' [report_title]"+@sql

/* output second report */
exec(@sql)

/*################################################# 
create the fraud savings graph data 
##################################################*/

/* report data values */
select @graph_limit=nullif(max(avg),0) from #report_tmp

select @graph_data=@graph_data+","+cast(isnull(cast((avg/@graph_limit)*100 as decimal(5,1)),0) as varchar) from #report_tmp order by idnum
select @graph_data=substring(@graph_data,2,len(@graph_data)) --remove leading comma

/* report labels */
select @graph_labels=@graph_labels+"|"+[month] from #report_tmp order by idnum

select @sql="select 'GRAPH' [report_type], 'Fraud Saving % - Graph' [report_title],'LINE' [graph_type], '"+@graph_data+"' [graph_data], '"+@graph_labels+"' [graph_labels], '"+cast(@graph_limit as varchar)+"' [graph_limit]"

/* output third report */
exec(@sql)

truncate table #report_tmp

/*################################################# 
create the average lifecycle table data 
##################################################*/

select @sql='',@graph_data='', @graph_labels=''

insert into #report_tmp ([month], [avg])
select left(datename(mm,[date]),3) + 
			case when datediff(yyyy,@fd,@td)>=1 then ' ' + cast(year([date]) as varchar) else '' end as [month],
		[avg]
from (
	select dateadd(m,d.digit-1,@fd) [date],
			isnull(avg(datediff(day, f.createdate, f.DateClosed)),0) [avg]
	from ppd3.dbo.digits d 
		 left join fraud f on 
			(month(dateadd(m,d.digit-1,@fd))=month(f.DateClosed)
			and year(dateadd(m,d.digit-1,@fd))=year(f.DateClosed))
			and f.dateclosed between @fd and @td
			and f.ClaimHandler=@handler
	where dateadd(m,d.digit-1,dateadd(dd, -(day(@fd) - 1), @fd))<@td
	group by d.digit
)x
order by x.[date]

/* generate dynamic sql */
select @sql=@sql+",'"+cast(avg as varchar)+"' as ["+[month]+"]" from #report_tmp order by idnum
select @sql="select 'DATA' [report_type], 'Average Claim Lifcycle % - Table' [report_title]"+@sql
exec(@sql)

/*################################################# 
create the average lifecycle table data 
##################################################*/

/* report y-axis upper limit */
select @graph_limit=max(avg) from #report_tmp

/* report data values */
select @graph_data=@graph_data+","+cast(isnull(cast(([avg]/case when @graph_limit=0 then 1 else @graph_limit end)*100 as decimal(5,1)),0) as varchar) 
from #report_tmp order by idnum

select @graph_data=substring(@graph_data,2,len(@graph_data)) --remove leading comma

/* report labels */
select @graph_labels=@graph_labels+'|'+[month] from #report_tmp order by idnum

select @sql="select 'GRAPH' [report_type], 'Average Claim Lifcycle % - Graph' [report_title],'LINE' [graph_type], '"
		+@graph_data+"' [graph_data], '"
		+@graph_labels+"' [graph_labels], '"
		+cast(@graph_limit as varchar)+"' [graph_limit]"
		
exec(@sql)

drop table #report_tmp

GO
