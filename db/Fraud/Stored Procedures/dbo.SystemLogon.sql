SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SystemLogon]
@UserID UserID,
@Password varchar(20),
@ip varchar(15)
as
declare @externalaccess smallint,@IPAllowed smallint,@LoggedOn varchar(20),@workstation varchar(100),@logonerror varchar(500)

set nocount on
set @logonerror=''

if exists (select * from ppd3.dbo.Logon l left join users u on l.userid=u.userid where u.UserID=@UserID or (l.UserID=@UserID and l.team='IT') )	-- check userId exists
begin
	if not exists (select * from ppd3.dbo.Logon l left join users u on l.userid=u.userid where (u.UserID=@UserID or (l.UserID=@UserID and l.team='IT')) and ppd3.dbo.encrypt(@password)=l.[password])	-- check pssword
	begin
		set @logonerror='The password you typed is incorrect.<br>Please check your Caps-Lock key.'
	end
end
else -- username does not match
	begin
		set @logonerror='Your Username was not recognised'
	end

if (@logonerror='') --all ok so get user details
begin
	update ppd3.dbo.logon set LastLoggedOn=getdate() where userid=@userid

	select '' logonerror, l.[ID],
	case when upper(l.UserID)='SYS'  then
		(select [description] from ppd3.dbo.syslookup where tablename='sys' and code=0)
	else
		e.Fname
	end Fname,
	coalesce (case when upper(l.UserID)='SYS' then
		(select [description] from ppd3.dbo.syslookup where tablename='sys' and code=1)
	else
		e.Sname
	end,'Internet User')
	Sname,
	'' as workstation,l.AccessLevel, sla.[description] as AccessLevelName,slu.[description] as UserRole
	,l.LogoffFailureCount lfc, isnull(l.team,'') team,
	case when upper(l.userID)=upper(@password) then 1 else 
		case when datediff(day,l.passwordchanged,getdate())>30 and l.accesslevel<6 then 2 else 0 end
	 end PWchange,company,l.icards, l.ForeignUser, l.OfficeID,isnull(l.teamleader,'') Teamleader, 
	case when l.team='IT' then 1 else r.roleid end [roleid],
	case when l.team='IT' then 'Management' else slt.[description] end [hub]
	from ppd3.dbo.Logon l
	left join users r on r.userid=l.userid
	left join ppd3.dbo.Employees e on l.UserFK=e.[ID]
	left join ppd3.dbo.SysLookup sla on sla.Code=l.AccessLevel and sla.Tablename='AccessLevel'
	left join ppd3.dbo.SysLookup slu on slu.Code=l.UserRole and slu.TableName='UserRole'
	left join SysLookup slt on slt.Code=r.team and slt.TableName='Team'
	where l.userID=@UserID 
end
else --return error msg
begin
	select @logonerror as logonerror
end
GO
