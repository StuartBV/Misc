SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AddReminder] 
@claimid int,
@for varchar(50),
@type varchar(50),
@date varchar(50),
@time varchar(50),
@note varchar(1000),
@UserID varchar(50)
as
declare
@reminder varchar(50),
@fullnote varchar(2000)

set nocount on
set dateformat dmy
Set transaction isolation level read uncommitted

select @reminder=description,
@fullnote='Reminder added:<li>for: '+@for+'</li><li>Reminder Type: '+@reminder+'</li><li>at: '+@date+' '+@time+'</li><li>Reason: '+@note+'</li>'
from dbo.ReminderTypes where Code=@type

insert into dbo.Reminders ( UserId, Type, DueDate, Claimid, Note, CreatedBy,CreateDate )
select @for, @type, cast(@date+' '+@time as datetime), @claimid, @note, @UserID, getdate()

exec dbo.AddNoteToClaim 
	@ClaimID = @claimid, 
    @note = @fullnote,
    @userid = @userid,
    @notereason=60




GO
