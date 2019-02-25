SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCardsReminder_email]
@reminderuserID UserID,
@userID userID,
@claimID varchar(50),
@alarmdate varchar(25),
@note varchar(4000)
as

declare @Recipient varchar(200),@SenderEmail varchar(200),@SenderName varchar(100),@Subject varchar(500),@logtxt varchar(100),
	@jmail int, @hr int, @err varchar(100),  @message varchar(8000), @source varchar(100),@description varchar(1000), @sentok int

select @recipient=e.fname + '.'+e.sname + '@bevalued.co.uk'
from ppd3.dbo.logon l join ppd3.dbo.employees e on l.userfk=e.[id] 
where l.userID=@reminderuserID

select @senderemail=e.fname + '.'+e.sname + '@bevalued.co.uk',
@sendername=e.fname + ' '+e.sname
from ppd3.dbo.logon l join ppd3.dbo.employees e on l.userfk=e.[id] 
where l.userID=@userID

set @message='A reminder has been scheduled for you on: ' + @alarmdate +'

For claim reference ' + cast(@claimID as varchar(7)) + '

The reminder was scheduled by ' + @sendername + '

Note text:
' + @note

set @subject='Reminder Scheduled from ' + @sendername

exec @sentok=ppd3.dbo.SendMailExecute @Recipient=@recipient,@SenderEmail=@SenderEmail,@SenderName=@Sendername,@Subject=@subject,@Body=@message

if isnull(@sentok,0)=0
begin
	raiserror ('Icards Reminder_Email failed; dbo.SendMailExecute.',18,1)
end
else
begin
	set @logtxt='Reminder notification sent to ' + @recipient
	insert into [log] (iCardsID,UserID,[type],[text])
	values (@ClaimID,@UserID,'10',@logtxt)
end
GO
