SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[GetDateTimeFromString](@Datetime varchar(20),@Time varchar(8),@ZoneID int)
returns datetimeoffset(2)
as
	-- Takes datetime as a string or seperate date and time and returns a datetimeoffset value for the given time zone
begin
	declare @d datetimeoffset(2)
	select @d=case when isdate(@datetime)=1 and (isdate(@time)=1 or @time='') then
		case when @time='' then @datetime else cast(@datetime as datetime) + cast(@time as datetime) end
	else null end
	return (
		select top 1 todatetimeoffset(@d,(tz.offset/60))
		from timezones tz
		join zones z on tz.id=z.id
		where  z.[enabled]=1 and  tz.LocalStartTime < @d and z.id=@zoneID 
		order by tz.starttime desc
	)
end
GO
