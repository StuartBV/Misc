SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[GetLocalDateTime](@ZoneID int)
returns datetime2(0)
as
begin
	return (
		-- Returns the NOW date and time for the given Time Zone based on GMT
		select top 1 dateadd(second,offset,sysutcdatetime())
		from timezones tz
		join zones z on tz.id=z.id
		where z.[enabled]=1 and tz.starttime < getutcdate() and z.id=@zoneID
		order by tz.starttime desc 
	)
end
GO
