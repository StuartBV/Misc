SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[TimeZoneName](@TimeZoneID int) returns varchar(50) as
begin
	return (
		select name from zones where id=@TimeZoneID
	)
end
GO
