SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetUserHistory]
@userid varchar(100),
@date varchar(10)
as

set nocount on
set dateformat DMY

select 
l.userid,
upper(l.fin) [case no],
c.claimid,
c.OriginClaimID [claim no],
ltrim(cu.Title+' '+cu.Fname+' '+cu.Lname) [Customer],
convert(varchar(12),l.TransDate,103) [Date],
convert(varchar(5),l.TransDate,108) [Time],
s.Description [Action Taken],
s2.Description [Current status],
f.OriginatingSys [System]
from FraudLog l with (nolock)
join fraud f with (nolock) on l.FIN = f.FIN
join claims c with (nolock) on f.ClaimID = c.ClaimID
join Customers cu with (nolock) on c.CustID=cu.ID
join sysLookup s with (nolock) on s.TableName='actiontaken' and s.code=l.ActionTaken
join sysLookup s2 with (nolock) on s2.TableName='fraudstatus' and s2.code=f.Status
where l.userid=@userid
and convert(varchar(10),l.transdate,103)=@date
and l.ActionTaken not in (99,4,5,6,7)
order by l.transdate desc,l.fin
GO
