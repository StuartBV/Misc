SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[GetLocalOffset](@ZoneID int, @scale char(1)='h')
returns decimal(6,2)
as
begin
	-- Returns the Time Zone Offset from GMT (inc daylight savings time) in hours/minutes/seconds
	return (
		select top 1
			case @scale
				when 'h' then 	 tz.OffsetHours
				when 'm' then 	 tz.OffsetMinutes
				when 's' then 	 tz.offset
			else 0
			end
		from timezones tz
		join zones z on tz.id=z.id
		where z.[enabled]=1 and tz.starttime < getutcdate() and z.id=@ZoneID
		order by tz.starttime desc 
	)
end
GO
