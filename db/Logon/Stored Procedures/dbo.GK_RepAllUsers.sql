SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GK_RepAllUsers] 
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

select 
	c.name [Client],
	u.fname + ' ' + u.sname [User],
	u.username [Username],
	isnull(convert(varchar(11),u.lastauth,113),'none') [Last Auth on], 
	isnull(convert(varchar(11),u.lastlogin,113),'none') [Last Login on],
	'All Users' [repname]
from userdata u  
left join clients c  on c.cid=u.clientid

where (u.clientid =  cast(@cid as varchar) or @cid='')
and u.username <> 'gkchangeme'

order by u.[LastAuth] desc
GO
