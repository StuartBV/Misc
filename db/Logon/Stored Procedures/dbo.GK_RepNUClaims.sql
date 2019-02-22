SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_RepNUClaims]
	@from varchar(20) ,
	@to varchar(20),
	@cid varchar (5)
AS
set dateformat dmy
set nocount on
set transaction isolation level read uncommitted
declare @fd datetime,@td datetime,@where varchar(1000),@sql varchar(2000)
select @fd=cast(@from as datetime),@td=cast(@to as datetime)

select [Name],TotalClaims [Total Claims],[Date],repname
from (
	SELECT c.[name],count(*) as [TotalClaims],
	convert(char(10),l.createdate,103) as [Date],'NU Claims' as repname
	FROM Userdata u
	Join AuthLog l on l.userid = u.username
	Join [Clients] c on u.clientid = c.cid
	where l.code=5 and c.[Parent]=7 and l.createdate between @fd and @td -- 7 indicates NU is parent client for NU sites.
	group by c.[name],convert(char(10),l.createdate,103)
	) x
order by convert(datetime,[date],103)
GO
