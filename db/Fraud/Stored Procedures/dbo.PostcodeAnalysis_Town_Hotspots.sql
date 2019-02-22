SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PostcodeAnalysis_Town_Hotspots]
@from varchar(10),
@to varchar(10)
as
--UTC--
set nocount on
set dateformat dmy
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select town,postcodes,total,(total/postcodes) [avg]
from (
	select cu.town,count(distinct(left(cu.Postcode,7))) [postcodes],count(*) [total]
	from ppd3.dbo.claims c join ppd3.dbo.Customers cu on c.CustID=cu.id
	where c.ClaimReceivedDateUTC between @fd and @td
	and c.CancelCode!=99 
	and cu.Postcode!=''
	group by cu.town
)x
order by 4 desc,1
GO
