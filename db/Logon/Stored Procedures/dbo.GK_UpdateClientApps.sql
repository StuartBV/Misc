SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_UpdateClientApps] 
	@userid varchar(30),
	@hash varchar(36), 
	@cid int,
	@param varchar(20)
AS SET nocount on
set transaction isolation level read uncommitted

declare @charpos smallint, @appid int

-- Only IT to be able to update Client Apps
if exists (select * from [UserData] u (nolock) where [UserName] = @userid and  [Hash] = @hash AND clientid=1 and isAdmin =2 AND u.Enabled=1 ) AND @param !=''
BEGIN

	begin tran

		set @charpos = charindex(',',@param)
		
		DELETE FROM ClientApps WHERE CID=@cid
		
		while @charpos>0
		begin
		  set @appid=left(@param,@charpos-1)
		  set @param=right(@param,len(@param)-@charpos)
		  set @charpos = charindex(',',@param)
		
		INSERT INTO ClientApps (CID,AID)
		SELECT @cid,@appid
		end

	commit tran
end

ELSE
	raiserror('User not authorised to update Client Apps ',1,1)
GO
