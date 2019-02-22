SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetAdminLists]
as
set nocount on

select 1 seq,'Select:' username,'All' userid
union all
select 2 seq,e.Fname+' '+e.Sname username,l.userID userid
from ppd3.dbo.Employees e
join ppd3.dbo.logon l on e.id=l.userfk
where l.accesslevel>0
order by seq,username

select 1 seq,'Select:' team,'All' code
union all
select 2 seq,sl.[description] team,sl.code code
from sysLookup sl
where tablename='team'
order by seq,code

select 1 seq,'Select:' [role],'All' code
union all
select 2 seq,sl.[description] [role],sl.code code
from ppd3.dbo.sysLookup sl 
where tablename='userrole'
and Extradescription='fraud'
order by seq,code

select 1 seq,'Select:' username,'All' userid
union all
select 2 seq,e.Fname+' '+e.Sname username,l.userID userid
from ppd3.dbo.Employees e
join ppd3.dbo.logon l on e.id=l.userfk
join fraud.dbo.users u on l.UserID = u.UserID
order by seq,username




GO
