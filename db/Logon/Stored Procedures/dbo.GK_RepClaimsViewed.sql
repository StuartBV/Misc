SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_RepClaimsViewed]
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

set @sql =	' select au.ClaimID,c.name as [Client],u.fname + '' '' + u.sname as [Username],convert(char(10),au.createdate,103) + '' '' + convert(char(5),au.[CreateDate],108) as Viewed,''Claims Viewed'' as repname ' +
		' from AuthLog au ' +
		' JOIN [UserData] u on au.[userid] = u.[UserName] ' +
		' JOIN [Clients] c on u.[ClientID] = c.[CID] ' +
		' where  [ClaimID] is not null and au.code=5 and  au.createdate between cast(''' + convert(varchar(16),@fd,112) + '''as datetime) and cast(''' + convert(varchar(16),@td,112) + ''' as datetime)'
		

set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end

set @sql = @sql + @where + ' order by au.createdate desc'
exec(@sql)
GO
