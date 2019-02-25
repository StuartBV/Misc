SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create FUNCTION [dbo].[FisResponseConCat] (@id int)  
RETURNS varchar(8000)
AS  
BEGIN

declare @cat varchar(8000)
set @cat=''

select @cat=@cat + '<li>' + scll.Description + ' - ' + convert(varchar(12),scl.CreatedDate,113) + '</li>'
from dbo.SupplierCardLog scl 
join syslookup scll ON scll.code=scl.StatCode and scll.tablename='FisStatusCode'
where scl.TransactionID=@id
order by scl.CreatedDate desc

if (@cat!='')
	set @cat='<b>Response(s) from FIS:</b><ul>'+@cat+'</ul>'

return @cat

END





GO
