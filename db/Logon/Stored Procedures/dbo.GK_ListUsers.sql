SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_ListUsers] 
	@cid int = 0,
	@deletelist int = 0,
	@hash varchar(36)=''
AS 
set nocount on
set transaction isolation level read uncommitted

declare @admin tinyint
set @admin=0
select @admin=isadmin from userdata ud  where [hash]=@hash

if @deletelist = 0 
begin
	select u.uid,u.[FName] +' ' + u.[SName] as [name],isAdmin,enabled
	from UserData u 
	where u.clientid = @cid and deleted !='Y' -- show non-deleted users
	and isadmin <= @admin -- Only show your admin level of user checking it or below.
	order by 2
end
else
begin
	select u.uid,u.[FName] +' ' + u.[SName] as [name],isAdmin,enabled
	from UserData u 
	where deleted ='Y' -- show deleted users
	order by 2
end
set transaction isolation level read committed
GO
