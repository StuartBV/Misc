SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE  FUNCTION [dbo].[LastIndexOf] 
	(@strValue VARCHAR(4000),
	@strChar VARCHAR(50)) 
RETURNS INT
AS
BEGIN
DECLARE @index INT
	
SET @index = 0

WHILE  CHARINDEX(@strChar, @strValue) > 0
	BEGIN
		SET @index = @index + CASE WHEN CHARINDEX(@strChar, @strValue) > 1 
					   THEN 
						(LEN(@strValue) - LEN(SUBSTRING(@strValue,CHARINDEX(@strChar, @strValue) + LEN(@strChar),LEN(@strValue)))) 
					    ELSE 
						1 
					    END
		SET @strValue = SUBSTRING(@strValue,CHARINDEX(@strChar, @strValue) + len(@strChar),LEN(@strValue))	
	END

	RETURN @index 
END

GO
