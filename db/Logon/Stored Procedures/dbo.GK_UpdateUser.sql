SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_UpdateUser] 
	@uid int,
	@username varchar (30),
	@fname varchar (30),
	@sname varchar (30),
	@client int = -1,
	@pw varchar(30),
	@enabled tinyint = 1,
	@isAdmin varchar(1),
	@glogin tinyint = 0,
	@IP varchar(20),
	@chpwnl tinyint = 0,
	@alteredby varchar(30)='sys',
	@deleted varchar(10) = ''
AS 
set nocount on
set transaction isolation level read uncommitted

declare @unresult int, @pwresult int,@result int,@logtxt varchar(100),@today datetime
set @unresult = 0
set @pwresult = 0
set @today =getdate()

if exists (select * from [UserData]  where uid = @uid)-- and deleted !='Y') -- if user exists and is not deleted
begin

	if @client != -1 and @client !='' -- none set.
	begin 
		update userdata set clientid = @client where uid = @uid -- admin level 2 supplied new client id.
	end
	-- Update F + S name, and username, as well as admin and account enabled.
	update userdata set fname = @fname, sname=@sname,
	 isAdmin=case when isAdmin > 1 then 2 else case when @isAdmin= '' then isAdmin else cast(@isAdmin as tinyint) end end,
	enabled=case when isAdmin > 1 then 1
			else case when @deleted = 'Y' then 0 
			else case when @enabled ='1' then cast(@enabled as tinyint)
			else case when @enabled ='' then 0 end end end end,
	changedpw=case when lastlogin is null OR  @chpwnl > 0 then null else case when @pw <> [password] and @pw != '' then @today else changedpw end end,
	globallogin=case when isAdmin > 1 then 1 else case when @glogin = '' then 0 else @glogin end end,
	altereddate=@today,alteredby=@alteredby,deleted=@deleted where uid = @uid 
	
	if not exists (select * from [UserData]  where username = @username and uid=@uid) --only update if userrname isn't different
	begin

		if exists (select * from userdata  where username like '%' + @username + '%')
		begin
			set @unresult = 1 -- username already exists.
		end
		else
		begin
			update userdata set username = @username where uid = @uid
		end
	end

	if @pw != '' -- only if a password given.
	begin
		--update password
		if exists (select * from PWExclude  where [password] like '%' +@pw + '%')
		begin
			set @pwresult = 1 -- password not secure.
		end
		else
		begin
			update [UserData] set [password] = @pw,
			-- update changed password date to now only if they have previously logged in. otherwise null.
			changedpw=case when lastlogin is null OR  @chpwnl > 0 then null else @today end where uid = @uid
		end
	end

	select   	@result=case 
			 when @deleted = 'Y' then 3 				-- just deleted an account.
			 when @unresult = 0 and @pwresult = 0 then 0 		--successful update
			  when @unresult = 1 and @pwresult = 0 then 1 		--successful pw, not username.
			  when @unresult = 0 and @pwresult =1 then 2		--successful name, not pw. 
			  else 4 end						--else  both unsuccessful. 

	set @logtxt = case when @result = 0 then  'Successful update of all supplied details.'
	when @result = 1 then'Successful PW change, Username exists'
	when @result = 2 then 'Successful Username change, Password unsecure'
	when @result = 3 then 'Account marked as deleted.'
	when @result = 4 then'Both username and password exist/unsecure'
	 else ' Unknown Error' end

	-- log update.
	exec GK_LogEntry @username,'',@IP,11,@logtxt,null,0,@alteredby,@result
	select @result -- successful update
end

else
begin
	select 9 as result -- user account doesn't exist or is deleted
end
GO
