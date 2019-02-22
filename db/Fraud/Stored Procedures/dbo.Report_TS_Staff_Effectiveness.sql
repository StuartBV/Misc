SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Report_TS_Staff_Effectiveness]
@from varchar(10),
@to varchar(10)
AS
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))

select CASE WHEN f.currenttier=1 THEN 'Tier 1' ELSE isnull(b.bookedfor,'unAssigned') end agent,
count(*) [closed],
isnull(f.ReasonClosed,'') [reasoncode],
sum(cp.Initial_Reserve) [savings]
from fraud f with (nolock)
join claims c with (nolock) on f.claimid=c.claimid
join ClaimProperties cp with (nolock) on c.ClaimID = cp.ClaimID
left join Bookings b with (nolock) on f.Bookingid=b.BookingID
where f.DateClosed between @fd and @td
group by CASE WHEN f.currenttier=1 THEN 'Tier 1' ELSE isnull(b.bookedfor,'unAssigned') end,
isnull(f.ReasonClosed,'')
order by 1,3
GO
