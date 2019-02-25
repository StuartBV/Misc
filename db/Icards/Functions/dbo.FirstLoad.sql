SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[FirstLoad](@icardsid int)  
RETURNS money
AS  
BEGIN
declare @value money

select top 1 @value=t.cardvalue 
from policies p with (nolock)
left join customers cu with (nolock) ON cu.ID=p.customerid
left join cards c with (nolock) ON c.customerid=cu.ID
left join transactions t with (nolock) ON t.cardid=c.ID
where p.[ICardsID]=@icardsid
order by t.createdate

return @value

END





GO
