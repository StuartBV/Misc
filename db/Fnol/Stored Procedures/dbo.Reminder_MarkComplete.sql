SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Reminder_MarkComplete]
@id int,
@claimid int,
@userid UserID
as
set nocount on
set dateformat dmy
declare @fullnote varchar(500), @dt datetime=getdate()

update dbo.Reminders set
	DateCompleted=@dt,
	LastActioned=@dt,
	AlteredBy=@userid,
	AlteredDate=@dt
where Claimid=@claimid and ID=@id


select @fullnote=rt.[Description]+' Reminder Actioned by '+ln.fullname
from reminders r join dbo.ReminderTypes rt on r.[type]=rt.code
join ppd3.dbo.LogonNames ln on ln.userid=@userid
where r.id=@id

exec dbo.AddNoteToClaim @ClaimID=@claimid, @note=@fullnote, @userid=@userid
GO
