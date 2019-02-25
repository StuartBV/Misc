SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ListUseriCardsAdminAccess]
@userID UserID
as

set nocount on
set transaction isolation level read uncommitted

select sl.[ID] AdminID, sl.[description] [option], case when a.userID is null then '' else 'checked' end granted, sl.extracode type
from iCards.dbo.syslookup sl
left join iCardsAdminAccess a on a.UserID=@userID and a.AdminID=sl.ID
left join ppd3.dbo.logon l on l.userid=@userID
where sl.tablename='AdminMenu' and sl.extracode='i'
and isnull(sl.extradescription,0)<=l.[AccessLevel]
order by sl.flags
GO
