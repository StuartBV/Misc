SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[reports_handlerlist] 
as
set nocount on

--list of TS handlers
select 1 as seq,'All' as title,'All' as [code]
union all
select 2 as seq,e.fname+' '+sname [title],l.userid [code]
from Users r 
join ppd3.dbo.logon l  on l.userid=r.userid
join ppd3.dbo.employees e  on e.id=l.userfk
order by 1,2
GO
