SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ConvertDateTimeToTimeZone](@Datetime datetime,@ZoneID int)
returns PPDate
as
begin
	return (
		select top 1 todatetimeoffset(cast(@Datetime as datetime2(2)),(tz.offsetminutes)) ConvertedDateTime
		from timezones tz
		join zones z on tz.id=z.id
		where z.[enabled]=1 and tz.LocalStartTime < @Datetime and z.id=@zoneID 
		order by tz.starttime desc
	)
end
GO
