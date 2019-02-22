SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[ConvertLegacyDateTimeToPPDate](@d datetime)
returns ppdate
as
-- Given a legacy date time value, returns a PPDate with correct timezone offset
begin

	return todatetimeoffset(@d, dbo.GetLocalOffsetForDate(@d,1610,'m') )

end
GO
