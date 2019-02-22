SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_RepPWChanged]
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

set @sql =	' select distinct c.name as [Client],u.fname + '' '' + u.sname as [User],convert(char(10),u.changedpw,103) + '' '' + convert(char(5),u.changedpw,108) as [Last changed on], ''Passwords Changed'' as repname ' +
		' from UserData u ' +
		' JOIN [Clients] c on c.[CID] = u.[ClientID] ' +
		' where u.[ChangedPW] between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''
		
set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end

set @sql = @sql + @where + ' order by 1,2'
exec(@sql)
GO
