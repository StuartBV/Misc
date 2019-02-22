SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GK_RepClaimViewTotalViews] 
@from varchar(10),
@to varchar(10),
@cid int
as
set dateformat dmy
set nocount on
set transaction isolation level read uncommitted

declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select x.[description] + ' ' + cast(x.[Year]  as varchar) as [date],x.Client, x.[User],x.[Total Viewed Claims], 'ClaimView Totals' as Repname
from (
	select top 100 percent datepart(year, au.createdate) as [year], datepart(month, au.createdate) as [month], mth.[Description], c.[name] Client, ud.fname + ' ' + ud.sname + ' (' + ud.username + ')' as [user], 
	count(*) as [Total Viewed Claims]
	from authlog au 
	join userdata ud on ud.username=au.userid
	join clients c on c.CID=ud.ClientID and 1=case when @cid=c.cid then 1 else case when @cid=0 then 1 else 0 end end
	join ppd3.dbo.sysLookup mth on mth.tablename='Months' and cast(mth.code as int)=datepart(month, au.createdate)
	where au.code='5' -- A successful viewed claim
	and au.createdate between @fd and @td
	group by datepart(year, au.createdate),datepart(month, au.createdate),mth.[Description],ud.[FName],ud.[SName], ud.username, c.[name]
	order by 1,2
) x
GO
