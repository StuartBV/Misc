SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCardsReminder_create]
@claimID varchar(50),
@reminderuserID UserID='',
@userID UserID,
@rtype char(1),
@rdate varchar(10)='',
@rtime varchar(5)='',
@rdays varchar(3)='',
@rhours varchar(2)='',
@note varchar(4000)=''
as
--UTC--
set nocount on
set dateformat dmy
set transaction isolation level read uncommitted

declare @dt datetime=getdate(),@alarm datetime,@d int, @h int, @noteID int, @daystart float,@dayend float, @alarmtime float, @logtxt varchar(100), @username varchar(100)='',@alarmtext varchar(25)
select @daystart=cast(cast('19000101 08:00' as datetime) as float), @dayend= cast(cast('19000101 20:00' as datetime) as float)


if @rtype='0'
begin
	if @rdays='' or @rhours=''
	begin
		raiserror ('Invalid reminder settings',15,1)
		return
	end
	select @d=cast(@rdays as int),@h=cast(@rhours as int)
	set @alarm=dateadd(d,@d,@dt)	-- Add days
	set @alarm=dateadd(hh,@h,@alarm)	-- Add hours
end
else
begin
	select @alarm= cast(@rdate + ' ' + @rtime as datetime)
end

if datediff(mi,@dt,@alarm)<1
begin
	raiserror('Cannot set reminder. The date is too close to the current date/time',15,1)
	return
end

set @alarmtime=cast(cast(convert(varchar,@alarm,114) as datetime) as float)
if @alarmtime < @daystart or @alarmtime > @dayend
begin
	raiserror('Cannot set reminder. The time of the reminder is outside of current working hours.',15,1)
	return
end

if @@error=0
begin

	if exists (
		select * from ppd3.dbo.reminders 
		where userID=@reminderuserID and iCardsID=@claimID and @alarm between dateadd(mi,-1,AlarmDateUTC) and dateadd(mi,1,AlarmDateUTC)
	)
	begin
		raiserror('Cannot set reminder. This reminder clashes with an existing reminder on this claim',15,1)
		return
	end

	begin tran
		if @note=''
			set @note='No note text was entered.'
		insert into notes (iCardsID,Note,createdate,createdby,notetype,notereason)
		values (@claimID,@note,@dt,@userID,30,0)
		set @noteID=scope_identity()

		insert into ppd3.dbo.reminders (userID,iCardsID,OriginalAlarmDateUTC,AlarmDateUTC,NoteID,CreatedBy)
		values (@reminderuserID,@claimID,dbo.SN_TimeZone_ConvertLegacyDateTimeToPPDate(@alarm),dbo.SN_TimeZone_ConvertLegacyDateTimeToPPDate(@alarm),@noteID,@userID)

		set @alarmtext=convert(varchar(11),@alarm,113) + ' at ' + convert(char(5),@alarm,114)

		set @logtxt='Reminder set, alarm time: ' +  @alarmtext
		if @userID <> @reminderuserID
		begin
			set @logtxt=@logtxt + ' For user ' + @reminderuserID
			-- Need to return user name
			select @username=e.fname + ' ' + e.sname
			from ppd3.dbo.logon l
			join ppd3.dbo.employees e on l.userfk=e.[id]
			where l.userID=@reminderuserID
			-- Send notification email
			exec iCardsreminder_email @reminderuserID,@userID,@claimID,@alarmtext,@note

		end
		insert into [log] (iCardsID,UserID,[type],[text],createdate)
		values (@ClaimID,@UserID,'10',@logtxt,getdate())


		select  @alarmtext Alarm, @username UserName
	commit tran
end


GO
