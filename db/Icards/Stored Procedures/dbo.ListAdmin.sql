SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ListAdmin]
@userID UserID
as

set nocount on

select distinct sys.[Description] [option],sys.code path,flags
from syslookup sys
left join iCardsAdminAccess a on (a.UserID=@userID and a.adminID=sys.[id])
where sys.tablename='AdminMenu' and sys.ExtraCode='i'
and 1=case when exists (select * from  ppd3.dbo.logon where userID=@userID and AccessLevel=6) then 1
	else case when a.adminID is null then 0 else 1 end end
order by sys.flags
GO
