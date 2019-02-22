SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ConvertToNewTimeZoneTVF](@PPDate PPDate,@ZoneID int)
returns table
as

	-- This does the same job as the function [dbo].[ConvertDateTimeToZoneTVF]
	-- The difference is that this function takes a PPDATE custom datatype which includes the limiting precision of (2) 
	return
	select top 1 switchoffset(@PPDate,(tz.offsetMinutes)) ConvertedDateTime
	from timezones tz
	join zones z on tz.id=z.id
	where z.[enabled]=1and tz.StartTime <= @PPDate and z.id=@ZoneID
	order by tz.starttime desc 
GO
