SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ConvertDateTimeToZone2](@d datetimeoffset,@ZoneID int)
returns datetimeoffset(2)
as
begin
	-- Takes any datetime with offset and converts to target time zone
	return (
		select top 1 switchoffset(@d,(tz.offset/60))
		from timezones tz
		join zones z on tz.id=z.id
		join countries c on c.code=z.code
		where z.[enabled]=1 and tz.LocalStartTime < @d and z.id=@ZoneID
		order by tz.starttime desc 
	)
end
GO
