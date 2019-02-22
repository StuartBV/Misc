SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_UserSecurity]
	@uid varchar(20)
AS
set nocount on
set transaction isolation level read uncommitted
-- get all user details.

select u.uid,cast(u.fname + ' ' + u.sname as varchar(30)) as [Name],fname,sname,username,
c.[name] as client,clientid,
convert(char(10),u.lastauth,103)+ ' ' + convert(char(5),u.lastauth,108) as lastauth,
convert(char(10),u.lastlogin,103)+ ' ' + convert(char(5),u.lastlogin,108) as lastlogin,
convert(char(10),u.changedpw,103)+ ' ' + convert(char(5),u.changedpw,108) as lastpwc,
isnull(cast(currentapplication as varchar(10)),'Not Set') as curapp, isnull(cast(currentpage as varchar(10)),'Not Set') as curpage,
u.enabled,IP,u.createdby,u.alteredby,
convert(char(10),u.altereddate,103)+ ' ' + convert(char(5),u.altereddate,108) as altereddate,isAdmin,
globallogin,deleted
from userdata u 
join Clients c  ON c.cid = u.clientid
where u.uid = @uid
GO
