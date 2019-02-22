SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE FUNCTION [dbo].[Pad] (
@string varchar(10), 	-- String to pad out
@length tinyint,	-- Length required
@padchar char(1))	-- Character to pad with
RETURNS varchar(10)
AS  
BEGIN
set @string=
	case when len(@string)>=@length then @string else
		replicate(@padchar,@length-len(@string)) + @string
	end
return @string
END
GO
