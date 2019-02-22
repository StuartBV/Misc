SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetClockSettings] 
as
select c.City, oh.OffsetHours
from Cities c
outer apply (
	select OffsetHours from TimeZones z
	where z.ID=c.TimeZoneID and z.StartTime=(select max(StartTime) from TimeZones zz where zz.ID=c.TimeZoneID and zz.StartTime < getutcdate())
)oh
order by 2

-- The above is twice as efficent
/*
select City, OffsetHours
from
(select c.City, OffsetHours, row_number() over (partition by c.City order by StartTime desc) as RowNum
from Cities c
join TimeZones z on z.ID = c.TimeZoneID
and StartTime < getutcdate()
) z
where z.RowNum = 1
order by z.OffsetHours
*/



GO
