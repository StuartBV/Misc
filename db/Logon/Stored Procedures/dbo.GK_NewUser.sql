SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GK_NewUser]
@userID UserID,
@hash varchar(50)
AS
set nocount on
set transaction isolation level read uncommitted

declare @ID int
declare @clientid int
set @ID=0

 --ensure user allowed to create new accounts.
if exists (select * from UserData u  where UserName = @userid and  Hash = @hash and isAdmin > 0)
begin

	-- select new user's client id. Set as admin's client ID Default clientID to 1 (PP) unless found.
	set @clientid = case when (select isAdmin from UserData u where UserName = @userid and  [Hash] = @hash) > 1 then 1
	else (select u.clientid from UserData u  where UserName = @userid and  [Hash] = @hash) end

	select @ID=[UID] from userdata where Fname='New GK' and Sname='Login' and clientid = @clientid -- add client clause in so 2 level 1 admins dont get same new user
	if @ID=0
	begin
		insert into UserData (ClientID,Fname,Sname,username,[password],[enabled],isadmin,createdby,createdate) 
		values (@clientID,'New GK','Login','gkchangeme','gkchangeme',1,0,@userID,getdate())
		set @ID= @@identity
	end

	select 0 as result,@ID as ID -- indicate success.

end
else
begin
	select 1 as result,@ID as ID -- not allowed to create account.
end
GO
