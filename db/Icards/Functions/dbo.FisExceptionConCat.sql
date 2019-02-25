SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create FUNCTION [dbo].[FisExceptionConCat] (@id int)  
RETURNS varchar(8000)
AS  
BEGIN

declare @cat varchar(8000)
set @cat=''

select @cat=@cat + '<li>' + ErrorMessage + ' - ' + convert(varchar(12),CreatedDate,113) + '</li>'
from dbo.FisExceptions
where RECID=@id
order by CreatedDate desc

if (@cat!='')
	set @cat='<b>FIS found the following issue(s): </b><ul>'+@cat+'</ul>'

return @cat

END





GO
