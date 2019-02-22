SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_CV_UpdateModuleAccess] 
	@userid varchar(30),
	@hash varchar(36),
	@cid int,
	@param varchar(1000)
AS
set nocount on
set transaction isolation level read uncommitted

declare @charpos smallint, @modulecode varchar(3)
create table #modules (cid int, code varchar(3)) 

-- Only IT to be able to update Client Apps
if exists (select * from [UserData] u  where [UserName] = @userid and  [Hash] = @hash AND clientid=1 and @cid<>0 and isAdmin =2 AND u.Enabled=1 ) AND @param !=''
BEGIN
	set @charpos = charindex(',',@param)
	
	while @charpos>0
	begin
		set @modulecode=left(@param,@charpos-1)
		set @param=right(@param,len(@param)-@charpos)
		set @charpos = charindex(',',@param)
	
		insert into #modules(cid,code)
		select @cid,@modulecode
	end
	
	-- 1. Update syslookup to set the access to 1 as anything in our table is allowed and also anything that isnt allowed.
	
	update sys
	set sys.flags=case when m.code is null then 0 else 1 end
	from syslookup sys
	left join #modules m on m.code=sys.extracode and m.cid=sys.code
	where sys.tablename='CVModulesAccess'
	and sys.code=@cid

	
	-- 1. insert any module for this client who doesnt have it already with access of "none" e.g. 0.
	
	insert into syslookup ([TableName],[Code],[Description],[Flags],[ExtraCode],[CreateDate],[CreatedBy])
	select 'CVModulesAccess' as tablename,@cid as code,sys.description,0 as flags,sys.code as extracode,getdate() as createdate,'markha' as createdby
	from  [ClientApps] ca  
	join syslookup sys  on [TableName]='CVModules'
	left join syslookup cva  on cva.tablename='CVModulesAccess' and cva.[ExtraCode]=sys.code and cva.code=cast(@cid as varchar)
	where ca.[CID]=@cid and ca.aid=1 -- only do it for ClaimView clients.
	and cva.code is null -- where it doesnt already exist

	drop table #modules
end

ELSE
	raiserror('User not authorised to update Client Apps ',1,1)
	
set transaction isolation level read committed
GO
