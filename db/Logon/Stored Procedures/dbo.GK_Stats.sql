SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_Stats]
	@from varchar(20) ,
	@to varchar(20),
	@cid varchar (5)
AS
set dateformat dmy
set nocount on
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime,@where varchar(1000),@sql varchar(2000)
select @fd=cast(@from as datetime),@td=cast(@to as datetime)

if @fd = '' OR  @td = '' 
begin
	set @td = getdate()
	set @fd = @td - 1
end

if @cid != '' 
begin
	set @where = ' and u.clientid = ' + @cid
end

-- 1. who was authorised
set @sql = 	' select c.name as [Client],u.fname + '' '' + u.sname as [User],convert(char(10),u.lastauth,103) + '' '' + convert(char(5),u.lastauth,108) as [Last Auth on], '+
		'  case when u.lastlogin is null then convert(char(10),u.lastauth,103) + '' '' + convert(char(5),u.lastauth,108) else convert(char(10),u.lastlogin,103) + '' '' +convert(char(5),u.lastlogin,108) end as [Last Login on],  ''Authorised Users'' as repname, ''authu'' as link ' +
		' from UserData u   ' +
		' JOIN [Clients] c  on c.[CID] = u.[ClientID] ' +
		' where  [LastAuth] between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''

set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end
set @sql = @sql + @where + ' order by u.[LastAuth] desc'

exec(@sql)

-- 2. Feedback left
set @sql = 	'select claimid [ClaimID],userid [User],c.[name] [Client],Feedback,a.createdate [Left on],''Feedback Left'' as repname, ''feedb'' as link ' +
		' from appfb a  ' +
		' Join userdata u  on a.userid = u.username ' +
		' Join clients c  on u.clientid = c.cid ' +
		' where a.createdate between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''

set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end
set @sql = @sql + @where + ' order by a.createdate desc'

exec(@sql)

-- 3. Which claims have been viewed
set @sql =	' select au.ClaimID,c.name as [Client],u.fname + '' '' + u.sname as [Username],convert(char(10),au.createdate,103) + '' '' + convert(char(5),au.[CreateDate],108) as Viewed,''Viewed Claims'' as repname, ''viewclaim'' as link ' +
		' from AuthLog au  ' +
		' JOIN [UserData] u  on au.[userid] = u.[UserName] ' +
		' JOIN [Clients] c  on u.[ClientID] = c.[CID] ' +
		' where  [ClaimID] is not null  and au.code=5 and  au.createdate between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''
		
set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end
set @sql = @sql + @where + ' order by au.createdate desc'

exec(@sql)

--4. passwords changed.
set @sql =	' select c.name as [Client],u.fname + '' '' + u.sname as [User],convert(char(10),u.changedpw,103) + '' '' + convert(char(5),u.changedpw,108) as [Last changed on], ''Passwords Changed'' as repname, ''pwchange'' as link ' +
		' from UserData u  ' +
		' JOIN [Clients] c  on c.[CID] = u.[ClientID] ' +
		' where u.[ChangedPW] between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''
		
set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end
set @sql = @sql + @where + ' order by 1,2'

exec(@sql)

-- 5. Account updates
set @sql =	' select  u.fname + '' '' + u.sname as [User],a.[IP],[Desc] as [Outcome], convert(char(10),a.createdate,103) + '' '' + convert(char(5),a.createdate,108) as [Update on],a.createdby [Update by], ''Account Updates'' as repname, ''accupd'' as link ' +
		' from AuthLog a  ' +
		' JOIN UserData u  on u.username = a.userid ' +
		--' JOIN [Clients] c  on c.[CID] = u.[ClientID] ' +
		' where a.code = 11 and a.[createdate] between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''
		
set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end
set @sql = @sql + @where + ' order by a.createdate desc'

exec(@sql)

-- 6. All from Auth log
set @sql =	' select  top 1000 userid [User], isnull(a.IP,''N/A'') as IP,isnull(cast(ClaimID as varchar(10)),''N/A'') as ClaimID,Code,[Desc] as [Description], ' +
		'isnull(cast(ExtraCode as varchar(10)),''N/A'') as [Extra Code],convert(char(10),createdate,103) + '' '' + convert(char(5),createdate,108) as [Date],a.[createdby] [Logged by], ''Authorisation Log (Top 1000)'' as repname, ''authlog'' as link ' +
		' from AuthLog a  ' +
		' JOIN UserData u  on u.username = a.userid ' +
		--' JOIN [Clients] c  on c.[CID] = u.[ClientID] ' +
		' where a.[createdate] between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''
		
set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end
set @sql = @sql + @where + ' order by createdate desc'

exec(@sql)
GO
