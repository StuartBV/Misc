SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetRiskValues]
as
set nocount on

select '-1' code,'Select:' [description]
union all
select code, [description]
from Syslookup 
where tablename='risk'
order by 1


GO
