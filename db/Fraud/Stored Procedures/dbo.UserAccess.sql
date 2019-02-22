SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UserAccess]
@userid UserID,
@ts tinyint,
@fnol tinyint,
@team tinyint=0,
@role tinyint=0
as
set nocount on
set transaction isolation level read uncommitted

declare @logonID int
select @logonID = id from ppd3.dbo.logon where userid=@userid

-- If TS=YES, and they dont exist, create user
if(@ts=1 and not exists(select * from users where userid=@userid) )
begin
	insert into fraud.dbo.Users (UserID,RoleID,Team)
	select @userid,@role,@team 
	
	if not exists(
		select * 
		from ppd3.dbo.Logon_AllowedApplications laa
		join ppd3.dbo.Logon_Applications la on la.Id=laa.ApplicationId
		where laa.UserID=@userid and la.ApplicationName='CMSFraud' 
	)
	begin
		insert into ppd3.dbo.Logon_AllowedApplications( UserID ,ApplicationId ,LogonId ,CreateDate ,CreatedBy)
        select @userid,la.Id, @logonID, getdate(),@userid
        from ppd3.dbo.Logon_Applications la
        where la.ApplicationName='CMSFraud'
	end
	
	update ppd3.dbo.logon set team='TS' where userid=@userid
end

-- If TS=YES, update Role, and Team
if @ts=1 
	begin
	if exists(select * from fraud.dbo.users where userid=@userid) 
	begin
		update fraud.dbo.users set RoleID=@role,Team=@team where userid=@userid
	end
	else
	begin 
		insert into fraud.dbo.Users (UserID, RoleID, Team, CallAllowance)
		values	(@userid,@role,@team,0)
	end
end

-- If TS=NO, delete user, their roles, and remove TEAM
if(@ts=0 and exists(select * from fraud.dbo.users where userid=@userid) )
begin

	delete from fraud.dbo.users where userid=@userid
	update ppd3.dbo.logon set team=null where userid=@userid
	
	delete from la
	from PPD3.dbo.Logon_AllowedApplications la
	join ppd3.dbo.Logon_Applications a on a.id=la.ApplicationId
	where la.UserID=@userid and a.ApplicationName='CMSFraud'

end

-- If FNOL=YES, and not there, create
if(@fnol=1 and not exists( select * from fnol.dbo.users r where r.userid=@userid ))
begin
	
	if not exists(
		select * 
		from ppd3.dbo.Logon_AllowedApplications laa
		join ppd3.dbo.Logon_Applications la on la.Id=laa.ApplicationId
		where laa.UserID=@userid and la.ApplicationName='fnol' 
	)
	begin
		
		insert into ppd3.dbo.Logon_AllowedApplications( UserID ,ApplicationId ,LogonId ,CreateDate ,CreatedBy)
        select @userid,la.Id, @logonID, getdate(),@userid
        from ppd3.dbo.Logon_Applications la
        where la.ApplicationName='fnol'         
	end	
	
	insert into fnol.dbo.users (userid,[Role],AuthLimit)
	select @userid,'FNOL_Advisor',0
end

-- If FNOL=NO, delete users roles
if(@fnol=0 and exists( select * from fnol.dbo.users r where r.userid=@userid ))
begin
	delete from fnol.dbo.users where userid=@userid
		
	delete from la
	from PPD3.dbo.Logon_AllowedApplications la
	join ppd3.dbo.Logon_Applications a on a.id=la.ApplicationId
	where la.UserID=@userid and a.ApplicationName='fnol'
end

GO
