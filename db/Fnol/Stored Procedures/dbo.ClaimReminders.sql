SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ClaimReminders] 
@claimid int
as

set transaction isolation level read uncommitted
set nocount on
set dateformat dmy

select r.id,rt.[Description] Reminder,r.[type] remindercode, r.note, 
case when r.userid='Manager' then 'FNOL Manager' else un.fullname end [ReminderFor],
convert(varchar(12),r.DueDate,13) due,
datediff(d,convert(varchar(12),getdate(),13),convert(varchar(12),r.DueDate,13) ) daysleft,
isnull(ln.fullname,'system') RaisedBy,r.CreatedBy handler,c.[Status]
from reminders r join fnol_claims c on r.ClaimID=c.ClaimID
join dbo.ReminderTypes rt on rt.code=r.[Type]
left join ppd3.dbo.LogonNames ln on r.CreatedBy = ln.userid
left join ppd3.dbo.LogonNames un on r.userid = un.userid
where r.claimid=@claimid and r.DateCompleted is null
order by r.DueDate 



GO
