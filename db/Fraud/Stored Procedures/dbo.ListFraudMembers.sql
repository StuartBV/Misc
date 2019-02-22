SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ListFraudMembers]
as
set nocount on
set transaction isolation level read uncommitted

select e.fname+' '+sname NAME,l.userid,r.roleid,s.[description]
from ppd3.dbo.syslookup s  
join Users r on cast(s.code as int)=r.roleid and s.tablename='userrole' and ExtraDescription='fraud'
join ppd3.dbo.logon l  on l.userid=r.userid
join ppd3.dbo.employees e  on e.id=l.userfk
where r.RoleID in (1,2,3)
and r.team>0
order by 1

GO
