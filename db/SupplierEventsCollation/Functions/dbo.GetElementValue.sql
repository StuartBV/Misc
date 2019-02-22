SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[GetElementValue](@xmlstring varchar(max),@elementname varchar(50))
returns varchar(50)
as
begin
	declare @elementnamelength tinyint=len(@elementname)+2, @start varchar(50)='<'+@elementname + '>', @end varchar(50)='</' + @elementname + '>'
	return(
	select substring(@xmlstring, charindex(@start,@xmlstring)+@elementnamelength ,  charindex(@end,@xmlstring) - (charindex(@start,@xmlstring)+@elementnamelength)  )  
)
end
GO
