SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GK_ProcessLogon]
@username UserID,
@password varchar(30),
@ip varchar(15)
as
set nocount on
set transaction isolation level read uncommitted

declare @procresult int, @dt datetime=getdate(),@lastlogin datetime, @IPOK tinyint, @PVAccess tinyint, @ipexpired int
set @procresult=-1

--eliminate IT having to login.
select @password=[password] from userdata where username=@username 
and 1= case when 
	(@username='markp' and @ip='192.168.5.5') or 
	(@username='stu' and @ip='192.168.5.1') or 
	(@username='RossNewark' and @ip='192.168.5.12') then 1 end

if exists (select * from UserData u where UserName=@username and [Password]=@Password and u.[Enabled]=1 and deleted ='')
begin
	select @IPOK=
	case when ip.ipaddress is null then 0 else 
		case when ip.ipexpires <= @dt then 0 
			else 1 
		end 
	end, 
	@PVAccess=case when ca.cid is null then 0 else 1 end,
	@ipexpired=case when ip.ipaddress is not null and ip.ipexpires <= @dt then 1 else 0 end
	from userdata u 
	join clients c on c.cid=u.clientid
	left join [ClientApps] ca on ca.[CID]=c.[CID] and ca.[AID]=7 -- This is Prod validator
	left join [IPLookup] ip on ip.[ClientID]=c.[CID] and @ip like replace(ip.ipaddress,'*','%')
	where u.username=@username and [password]=@password
		
	-- If they don't have an IP, and we are not LOCAL, then Boot.
	if (@ipok=0) and (left(@ip,7) != '192.168' and left(@ip,5)!='10.10' and @ip !='127.0.0.1' and left(@ip,7) != '10.0.10')
	begin
		select @procresult= case when @ipexpired=0 then 7 else 8 end
		select @procresult,'' as [hash],'' as pwchange,'' as uid,-1 as isAdmin,'' as cid
		exec GK_LogEntry @userid=@username, @password=@password, @ip=@ip, @code=@procresult,@desc=''
		return
	end
	
	-- Firstly check login period. If greater than 90 days (3 months)
	select @lastlogin=lastlogin from UserData where username=@username and [password]=@password
	if datediff(day,@lastlogin,@dt)>=90
	begin
		update userdata set
			[enabled]=0,
			alteredby='System',
			altereddate=@dt
		where username=@username and [password]=@password
		and isAdmin < 2 and globallogin < 1 and (alteredby != 'System' and userdata.[enabled]=1 and datediff(day,@dt,altereddate) >= 90 ) -- exclude super users and global logins, and re-enabled users.

		if @@rowcount > 0 -- if we have disabled the user. boot them out.
		begin
			select 2 as procresult,'' as [hash],'' as pwchange,'' as uid,-1 as isAdmin,'' as cid
			return
		end
	end

	-- Update UserData and set hash value
	update UserData set LastAuth=@dt,[hash]=case when globallogin =1 then [hash] else cast(newid() as varchar(36)) end, ip=@ip, LastLogin=LastAuth
	where UserName=@username and [password]=@Password and userdata.[enabled]=1
	
	set @procresult=0
	-- Return success to calling page
	select @procresult as ProcessResult, hash,
	case when GlobalLogin=1 then 0 else 	 -- eliminate pwchange for global logins.
	case when ClientID=3 then 0 else	 -- eliminate goldsmiths from changing P/W (links to public scans)
	case when ChangedPW is null then 1 else -- indicate a first login.
	case when datediff(day,ChangedPW,@dt)>30 then 2 else 0 end end end end as pwchange,uid,isAdmin,c.cid
	from UserData u join Clients c on c.CID=u.ClientID
	where UserName=@username and [password]=@Password and u.[enabled]=1
end
else
begin
	if exists(select * from Userdata u where username=@username and u.[enabled]=1 and [password]!=@password)
	begin
		--Password Incorrect
		set @procresult=1
	end

	if exists(select * from UserData u where username=@username and u.[enabled]=0)
	begin
		--Account Disabled
		set @procresult=2
	end

	if not exists(select * from UserData where username=@username)
	begin
		--Incorrect UserName
		set @procresult=3
	end

	if exists(select * from UserData where username=@username and deleted='Y')
	begin
		set @procresult=4
	end

	if @procresult < 0 -- indicating unknown error.
	begin
		--Unknown Error
		set @procresult=5
	end

	select @procresult,'' as [hash],'' as pwchange,'' as uid,-1 as isAdmin,'' as cid --, '' as WVcode
end

exec GK_LogEntry @username, @password, @ip, @procresult,''

return

GO
