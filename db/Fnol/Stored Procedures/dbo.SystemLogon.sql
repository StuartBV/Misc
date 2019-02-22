SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[SystemLogon]
@UserID UserID,
@Password varchar(20),
@ip varchar(15),
@team varchar(10)=''
as
set nocount on
set transaction isolation level read uncommitted

declare @externalaccess smallint,@IPAllowed smallint,@LoggedOn varchar(20),@workstation varchar(100),@logonerror varchar(500)=''

if exists ( select * from ppd3.dbo.Logon l left join users r on l.userid=r.userid where r.UserID=@UserID or (l.userid=@UserID and l.team='IT'))	-- check userId exists or a member of IT
begin
	if exists (select * from ppd3.dbo.Logon l where l.UserID=@UserID and ppd3.dbo.encrypt(@password)=[password])	-- check password
	begin
		select 
		@LoggedOn='', -- removed to allow users to be logged into both CMS and Fraud at same time
		@workstation='',@externalaccess=externalaccess, @IPAllowed=case when ip.IP is null then 0 else 1 end
		from ppd3.dbo.Logon l 
		left join ppd3.dbo.logonip ip on l.userid=ip.userid and ip.IP=@ip
		where l.UserID=@UserID	-- Required to get around SQL ignoring spaces on end

		--check if external access is allowed
		if (left(@ip, 7) != '192.168' and left(@ip, 5) != '10.10' and @ip != '127.0.0.1')
			begin
				if (@externalaccess=0) begin set @logonerror = 'You are not authorised to log on from your current location' end
				if (@IPAllowed=0) begin set @logonerror = 'You are not authorised to log on from IP address ' + @ip + '<br>A security event has been raised, your IP will be investigated.'  end
			end
		else
			begin
				set @externalaccess=1
				set @IPAllowed=1
			end

		--check if user is already logged in
		if (@LoggedOn!='')
			begin
				set @logonerror='You are aready logged on at machine '
				if (@workstation='')
					begin
						set @logonerror=@logonerror+'address ' + @LoggedOn
					end
				else
					begin
						set @logonerror=@logonerror + @LoggedOn
					end
			end
	end
	else -- password does not match
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
	
	--get user details
	select '' logonerror, l.[ID],
	case when upper(l.UserID)='sys'  then
		(select [description] from ppd3.dbo.syslookup where tablename='sys' and code=0)
	else
		e.Fname
	end Fname,
	coalesce (case when upper(l.UserID)='sys' then
		(select [description] from ppd3.dbo.syslookup where tablename='sys' and code=1)
	else
		e.Sname
	end,'Internet User') Sname,
	u.[role] as UserRole,
	isnull(l.team,'') team,
	isnull(u.AuthLimit,0) authlimit,
	l.AccessLevel,
	case when left(@ip, 7) != '192.168' and left(@ip, 5) != '10.10' and @ip != '127.0.0.1' then 1 else 0 end [ExternalIP]
	from ppd3.dbo.Logon l
	join users u  on u.userid=l.userid
	join ppd3.dbo.Employees e on l.UserFK=e.[ID]
	where l.userID=@UserID
	
	union 
	/* for IT team auto logon */
	select '' logonerror, l.[ID],
	case when upper(l.UserID)='sys'  then
		(select [description] from ppd3.dbo.syslookup where tablename='sys' and code=0)
	else
		e.Fname
	end Fname,
	coalesce (case when upper(l.UserID)='sys' then
		(select [description] from ppd3.dbo.syslookup where tablename='sys' and code=1)
	else
		e.Sname
	end,'Internet User') Sname,
	'Fraud Manager' as UserRole,
	isnull(l.team,'') team,
	100000 as authlimit,
	l.AccessLevel,
	case when left(@ip, 7) != '192.168' and left(@ip, 5) != '10.10' and @ip != '127.0.0.1' then 1 else 0 end [ExternalIP]
	from ppd3.dbo.Logon l	
	join ppd3.dbo.Employees e on l.UserFK=e.[ID] and l.team='IT'
	where l.userID=@UserID 

end
else --return error msg
begin
	select @logonerror as logonerror
end

GO
