SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[listResourcesByHub] as

set nocount on
set transaction isolation level read uncommitted

select e.fname+'<br>'+e.sname NAME,l.userid,s.[Description] [hub]
from Users r  
join ppd3.dbo.logon l  on l.userid=r.userid 
join ppd3.dbo.employees e  on e.id=l.userfk
join syslookup s on s.code=r.team and s.tablename='team'
order by 1
GO
