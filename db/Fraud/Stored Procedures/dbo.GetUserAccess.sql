SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetUserAccess]
@userid UserID
as
set nocount on
set transaction isolation level read uncommitted

select l.userid,
case when u.userid is null then 0 else 1 end [ts],
case when r.userfk is null then 0 else 1 end [fnol],
isnull(u.Team,'') [team], isnull(u.roleid,'') [roleid]
from ppd3.dbo.logon l 
left join users u  on u.userid=l.userid
left join ppd3.dbo.userroles r on r.userid=l.userid and r.[Application]='Fnol'
where l.userid=@userid
GO
