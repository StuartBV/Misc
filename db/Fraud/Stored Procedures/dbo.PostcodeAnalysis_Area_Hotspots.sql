SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PostcodeAnalysis_Area_Hotspots]
@from varchar(10),
@to varchar(10),
@town varchar(50)=null
as
--UTC--
set nocount on
set dateformat dmy
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select left(cu.Postcode,7) [area],cu.town,count(*) [total]
from ppd3.dbo.claims c join ppd3.dbo.Customers cu on c.CustID=cu.id
where c.ClaimReceivedDateUTC between @fd and @td
and c.CancelCode!=99 and cu.Postcode != ''
and cu.town=case when @town is null then cu.town else @town end
group by left(cu.Postcode,7),cu.town
order by 3 desc,2

GO
