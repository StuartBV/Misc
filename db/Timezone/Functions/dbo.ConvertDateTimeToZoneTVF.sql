SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ConvertDateTimeToZoneTVF](@d datetimeoffset,@ZoneID int)
returns table
as
	-- Takes a datetimeoffset datatype (probably PPDATE) which is the current date/time as represented by the included offset from UTC, and the timezone to convert to.
	-- So if you passed a value of '2013-08-06 10:00:00 +10:00' as @d, that means in effect the UTC equivalent is midnight.
	-- If you passed 1610 (UK) as the target timezone, given the date being in august, UK is in BST which means our clocks are 1 hour ahead of UTC
	-- Therefore the converted value will be '2013-08-06 01:00:00 +01:00'
	-- Which means the source date time was 10am in Australia, which was actually UTC midnight + 10 hours, so the new time in UK timezone is 1am, UTC + 1 hour (for BST)
return	
	select top 1 switchoffset(@d,(tz.OffsetMinutes)) ConvertedDateTime
	from timezones tz
	join zones z on tz.id=z.id
	where z.[enabled]=1 and tz.LocalStartTime < @d and z.id=@ZoneID
	order by tz.starttime desc 
GO
