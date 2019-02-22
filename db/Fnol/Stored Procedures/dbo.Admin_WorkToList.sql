SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Admin_WorkToList]
as

set nocount on 

select u.code userid, u.[description] fullname, w.id,w.ReminderType,rt.[Description] reminder
from (
	select l.fullname [description], lower(u.UserID) [code]
	from dbo.Users u	join ppd3.dbo.LogonNames l on u.UserID = l.userid
	where u.PrimeUser=1
	and u.role!='FNOL_Manager'
) u
left join dbo.WorkToList w on u.code=w.UserId
left join dbo.ReminderTypes rt on rt.code=w.ReminderType
order by 1
GO
