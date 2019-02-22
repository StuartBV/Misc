SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_RepClientSuccessLogin] 
AS
set nocount on
set transaction isolation level read uncommitted
select c.CID [ClientID],
c.name ClientName, 
max(l.[CreateDate]) as LastSuccessfulLogin 
from logon.dbo.[AuthLog] l 
join userdata u on u.username=l.[userid]
join clients c on c.[CID]=u.[ClientID]
where l.[Code]='0' -- Successful Login
group by c.cid,c.name

order by 3
GO
