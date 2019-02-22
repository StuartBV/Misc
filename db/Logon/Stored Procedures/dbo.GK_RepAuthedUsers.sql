SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_RepAuthedUsers] 
	@from varchar(20) ,
	@to varchar(20),
	@cid varchar (5)
AS
set dateformat dmy
set nocount on
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime,@where varchar(1000),@sql varchar(1000)
select @fd=cast(@from as datetime),@td=cast(@to as datetime)

if @fd = '' OR  @td = '' 
begin
	set @td = getdate()
	set @fd = @td - 1
end

set @sql = 	' select c.name as [Client],u.fname + '' '' + u.sname as [User],convert(char(10),u.lastauth,103) + '' '' + convert(char(5),u.lastauth,108) as [Last Auth on], '+
		'  case when u.lastlogin is null then convert(char(10),u.lastauth,103) + '' '' + convert(char(5),u.lastauth,108) else convert(char(10),u.lastlogin,103) + '' '' +convert(char(5),u.lastlogin,108) end as [Last Login on],  ''Authorised Users'' as repname ' +
		' from UserData u (nolock)  ' +
		' JOIN [Clients] c (nolock) on c.[CID] = u.[ClientID] ' +
		' where  [LastAuth] between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''

set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end

set @sql = @sql + @where + ' order by u.[LastAuth] desc'
exec(@sql)
GO
