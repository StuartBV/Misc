SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_CV_Access] 
@userid varchar(30),
@hash varchar(36),
@cid int =0
AS
set nocount on
set transaction isolation level read uncommitted

if exists (select * from [UserData] u  where [UserName] = @userid and  [Hash] = @hash and enabled=1)
begin
	if @cid=0 
	begin
		select cv.[Description], cva.flags as Access,cv.Code,cv.[ExtraDesc] as URL
		from userdata ud 
		join clients c  on c.cid=ud.clientid
		join syslookup cva  on cva.code=c.[CID] and cva.[TableName]='CVModulesAccess'
		join syslookup cv  on cv.[TableName]='CVModules' and cv.code=cva.[ExtraCode]
		where ud.[UserName]=@userid and [hash]=@hash and ud.[Enabled]=1
	end
	else -- else we are in client admin and want to see what access they have (if applicable). If null - access is zero as they dont have a lookup entry.
	begin
		select cv.[Description],isnull(cva.flags,0) as access,cv.code,cv.[ExtraDesc]
		from clients c  
		join syslookup cv  on cv.[TableName]='CVModules'
		left join syslookup cva  on cva.[TableName]='CVModulesAccess' and cva.code=c.cid and cv.code=cva.extracode
		where c.cid=@cid
	end

end
else
begin
	raiserror('User not enabled',1,1)
end
set transaction isolation level read committed
GO
