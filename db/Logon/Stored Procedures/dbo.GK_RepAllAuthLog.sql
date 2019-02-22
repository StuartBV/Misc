SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_RepAllAuthLog]
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

set @sql =	' select  userid [User], a.IP,isnull(cast(ClaimID as varchar(10)),''N/A'') as ClaimID,Code,[Desc] as [Description], ' +
		'isnull(cast(ExtraCode as varchar(10)),''N/A'') as [Extra Code],convert(char(10),createdate,103) + '' '' + convert(char(5),createdate,108) as [Date],a.[createdby] [Logged by], ''Authorisation Log'' as repname ' +
		' from AuthLog a (nolock) ' +
		' JOIN UserData u (nolock) on u.username = a.userid ' +
		--' JOIN [Clients] c (nolock) on c.[CID] = u.[ClientID] ' +
		' where a.[createdate] between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''
		
set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end

set @sql = @sql + @where + ' order by createdate desc'
exec(@sql)
GO
