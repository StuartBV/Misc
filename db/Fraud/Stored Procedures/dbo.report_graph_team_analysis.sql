SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[report_graph_team_analysis]
@team INT=null,
@from varchar(10),
@to varchar(10)
AS
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
declare @fd datetime,@td DATETIME,@data VARCHAR(8000),@labels VARCHAR(8000),@total money
select @fd=cast(@from as datetime),@td=dateadd(d,1,cast(@to as datetime))
set @labels=''
set @data=''

CREATE TABLE #tmp (agent VARCHAR(50),savings MONEY)

INSERT INTO #tmp (agent,savings)
SELECT b.bookedfor, SUM(cp.[Amount_Claimed]-ISNULL(c.excess,0))
from fraud f 
JOIN claims c  ON f.ClaimID = c.ClaimID
JOIN ClaimProperties cp  ON c.ClaimID = cp.ClaimID
JOIN Bookings b  ON f.bookingid = b.BookingID
JOIN users u  ON b.BookedFor=u.UserID
join [sysLookup] sys on sys.tablename='team' and sys.code=u.Team
WHERE f.DateClosed BETWEEN @fd AND @td
AND u.team=CASE WHEN @team IS null then u.team ELSE @team end
GROUP BY b.bookedfor

SELECT @total=SUM(savings) FROM #tmp

SELECT 
@labels=@labels+CASE WHEN @labels<>'' THEN '|' ELSE '' end+agent,
@data=@data+CASE WHEN @data<>'' THEN ',' ELSE '' end+CAST(ROUND((savings/@total)*100,2) AS VARCHAR)
FROM #tmp

SELECT 'http://chart.apis.google.com/chart?chs=550x350&cht=p&chco=3875c8&chd=t:'+@data+'&chl='+@labels AS [url]

SELECT * FROM #tmp

DROP TABLE #tmp


set transaction isolation level read committed


GO
