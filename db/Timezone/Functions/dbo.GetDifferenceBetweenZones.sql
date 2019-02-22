SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[GetDifferenceBetweenZones] (@Z1 int, @DT1 datetimeoffset, @Z2 int, @DT2 datetimeoffset,@scale char(1)='h')
returns decimal(6,2)
as
begin
	-- Returns the offset difference between two timezones in hours/minutes/seconds
	-- @Z1 Source Zone
	-- @Z2 Target Zone
	return (
		select 
				case @scale
					when 'h' then		round(diff/60/60.0,2)
					when 'm' then		diff/60
					when 's' then		diff
				else 0
				end
		from (
			select 
				(
					select top 1 tz.Offset Offset1 
					from timezones tz
					join zones z on tz.id=z.id
					where z.[enabled]=1 and tz.localstarttime < @DT2 and z.id=@Z2
					order by tz.starttime desc 
				) -
				(
					select top 1 tz.Offset Offset2
					from timezones tz
					join zones z on tz.id=z.id
					where z.[enabled]=1 and tz.localstarttime < @DT1 and z.id=@Z1
					order by tz.starttime desc 
				) Diff
			)x
	)
end
GO
