SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[XML_Escape](@string varchar(1000))
returns varchar(1000)
AS
begin
	return rtrim(ltrim(replace(isnull(@string,''),'&','&amp;')))
end
GO
