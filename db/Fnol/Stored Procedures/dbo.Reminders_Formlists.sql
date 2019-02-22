SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Reminders_Formlists] as

set transaction isolation level read uncommitted
set nocount on

--handlers that can be assigned reminders
select 1 seq,'Show All' [description],'All' [code]
union all
select 2 seq,'FNOL Manager' [description],'Manager' [code]
union all
select 3 seq,l.fullname [description], lower(u.UserID) [code]
from dbo.Users u
join ppd3.dbo.LogonNames l on u.UserID = l.userid
where u.PrimeUser=1 and u.[role]!='FNOL_Manager'
order by seq,[Description]

--reminder types
select 1 seq,'Show All' [description],'All' [code],0 [daysuntildue],0 [actiontype]
union all
select 2 seq,[Description],code,daysuntildue, ActionType
from dbo.ReminderTypes
order by seq,[Description]

GO
