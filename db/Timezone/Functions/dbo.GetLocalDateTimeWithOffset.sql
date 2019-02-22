SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[GetLocalDateTimeWithOffset](@ZoneID int)
returns datetimeoffset(2)
as
begin
	return (
	-- Returns GMT time with Offset for local time for time zone
	select top 1 switchoffset(cast(sysutcdatetime() as datetimeoffset(2)),OffsetMinutes )
	from timezones tz
	join zones z on tz.id=z.id
	where  z.[enabled]=1 and tz.starttime < getutcdate() and z.id=@zoneID
	order by tz.starttime desc 
	)
end
GO
