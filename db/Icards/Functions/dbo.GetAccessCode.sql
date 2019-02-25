SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create FUNCTION [dbo].[GetAccessCode] (@data varchar(500))  
RETURNS varchar(500) AS  
BEGIN

DECLARE @cString VARCHAR(32)
DECLARE @nPos    INTEGER
SELECT  @cString = @data
SELECT  @nPos = PATINDEX('%[^0-9]%', @cString)

WHILE @nPos > 0
BEGIN
SELECT @cString = STUFF(@cString, @nPos, 1, '')
SELECT  @nPos = PATINDEX('%[^0-9]%', @cString)
END

return @cString

END
GO
