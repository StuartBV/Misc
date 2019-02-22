SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[PPGetDate](@ZoneID int)
returns datetimeoffset(2)
as
begin
	-- Return the current time for the specified timezone including offset from UTC
	-- Use this to populate any PPDate UTC datatype column
	return (
	
	select top 1 switchoffset(cast(sysutcdatetime() as datetimeoffset(2)),OffsetMinutes )
	from timezones tz
	join zones z on tz.id=z.id
	where  z.[enabled]=1 and tz.LocalStartTime < getutcdate() and z.id=isnull(@ZoneID,1610)
	order by tz.starttime desc 
	)
end
GO
