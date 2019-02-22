SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ConvertDateTimeToTimeZoneTVF](@Datetime datetime,@ZoneID smallint)
returns table
as
	-- Takes a normal datetime and returns a datetimeoffset version of the datetime converted to the target timezone with the new time being UTC.
	-- Note this does not change the datetime value at all, but adds the zone offset information such that it is now "that time as UTC in the target time zone"
	return 
	select top 1 todatetimeoffset(cast(@Datetime as datetime2(2)),(tz.offsetminutes)) ConvertedDateTime
	from timezones tz
	join zones z on tz.id=z.id
	where z.[enabled]=1 and tz.LocalStartTime < @Datetime and z.id=@zoneID 
	order by tz.starttime desc
	
	/*
		Example:
		select * from ConvertDateTimeToTimeZoneTVF (getdate(),370)	-- Assume current time is 10:00 wherever you are. 370 is Melbourne Australia and right now they are 10 hours ahead
		datetimeoffset datatype returned will have value of '2013-08-06 10:00:00 +10:00'
		Read this to mean, the time now is ten oclock which is ten hours ahead of UTC time (in effect the UTC time will be midnight)

	*/
	
GO
