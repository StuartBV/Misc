SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_RepUserUpdates]
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

set @sql =	' select  u.fname + '' '' + u.sname as [User],a.[IP],[Desc] as [Outcome], convert(char(10),a.createdate,103) + '' '' + convert(char(5),a.createdate,108) as [Update on],a.createdby [Update by], ''Account Updates'' as repname ' +
		' from AuthLog a  ' +
		' JOIN UserData u  on u.username = a.userid ' +
		--' JOIN [Clients] c  on c.[CID] = u.[ClientID] ' +
		' where a.code = 11 and a.[createdate] between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''
		
set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end

set @sql = @sql + @where + ' order by a.createdate desc'
exec(@sql)

GO
