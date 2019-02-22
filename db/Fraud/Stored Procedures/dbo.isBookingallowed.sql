SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[isBookingallowed] 
@userid varchar(50),
@start varchar(20)
as

/*
This SP check a set of business rules to determine if a booking
can be made for a handler.
Current Rules:
1) Only so many handlers within a Team can be screening at any one time
2) Handlers are only allowed to make a limited number of screenings per day
*/

declare 
@teambookings int,
@teamallowance int,
@userbookings int,
@userallowance int,
@bookingstart datetime,
@bookingend datetime

set nocount on
set dateformat dmy

select 
@bookingstart=cast(convert(varchar(10),cast(@start as datetime),103)+ ' 00:00' as datetime),
@bookingend=cast(convert(varchar(10),cast(@start as datetime),103)+ ' 23:59:59' as datetime)

select @teamallowance=s.ExtraCode,@userallowance=u.CallAllowance
from users u with (nolock) 
join sysLookup s on u.team=s.code and s.tablename='team'
where u.userid=@userid

IF (datePart(dw,@start) BETWEEN 1 AND 5) -- only apply limits during working week
 begin

	select @teambookings=count(*)
	from users u with (nolock)
	join Bookings b with (nolock) on b.BookedFor=u.userid 
	where u.team in (select team from users where userid=@userid)
	and b.[type]='scr'
	and @start between b.startdate and dateadd(mi,-1,b.enddate) 
	and b.[type]='scr'
	and b.DeletedDate is null

	select @userbookings=count(*)
	from Bookings
	where BookedFor=@userid 
	and startdate between @bookingstart and @bookingend
	and [type]='scr'
	and DeletedDate is null

 end
ELSE
 begin
	select @teambookings=-1,@userbookings=-1
 end

--select @teambookings,@teamallowance,@userbookings,@userallowance,@bookingstart,@bookingend

select 
case 
	when @teambookings>=@teamallowance then 'Max No screenings reached for this time!'
	when @userbookings>=@userallowance then 'Max No daily screenings reached for '+@userid 
	else 'ok' 
end [bookingallowed]


GO
