SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_RepFeedback] @from varchar(20) ,@to varchar(20), @cid int
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

set @sql = 	'select claimid [ClaimID],u.Fname + '' ''+ u.Sname [User],c.[name] [Client],Feedback,a.createdate [Left on],''Feedback Left'' as repname ' +
		' from appfb a ' +
		' Join userdata u on a.userid = u.username ' +
		' Join clients c on u.clientid = c.cid ' +
		' where a.createdate between ''' + convert(varchar(10),@fd,112) + ''' and ''' + convert(varchar(10),@td,112) + ''''

set @where = case when cast(@cid as int) > 0 then '  and u.clientid = ' + cast(@cid as varchar) else ' ' end

set @sql = @sql + @where + ' order by a.createdate desc'
exec(@sql)

GO
