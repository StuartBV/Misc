SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[LogFirstContactEvent]
@claimID int,
@userid userid='sys',
@outcome varchar(20)
as
--UTC--
set nocount on
declare @txt varchar(max), @createdate datetime, @answered int, @notereason int,@eventID int


	--Update data based on whether FirstContact was Answered or Not
	set @answered=case when @outcome='answered' then 1 else 0 end
	set @txt='Customer contact attempt: '
	
	begin tran
		 
		insert into ppd3..claimevents (claimID,type,createdby,startdate)
		values (@claimID,0,@userID,dateadd(hour,2,getdate()))
		select @eventID=scope_identity()

		-- Log actioning this event
		update ppd3..claimevents set actioneddate=getdate(), actionedby=@userID,
				startedactioning=0, startedactioningby=null, StartedActioningDate=null
		where claimid=@claimID and eventID=@eventID
		
		-- Set initial claim-level first contact date and phone. 
		-- If date already set then leave alone
		-- If date already set do not touch contactbyphone either
		update ppd3..claims set
			firstcontactdateUTC=isnull(firstcontactdateUTC,ppd3.dbo.PPGetDate(TimeZoneID)),
			contactbyphone=case when firstcontactdateUTC is null then @answered else contactbyphone end
		where claimid=@claimid

		update Claims
		set FirstContactDate=getdate()
		where OriginClaimID=@claimid
		
		insert into ppd3..claimEventProperties (eventID,[name],[value],createdby)
		select @eventID,'Contact', case when @answered=1 then '10' else '20' end, @userID
		

		if @answered=1
		begin
			set @txt=@txt + 'Contact was successful.' + char(13)
		end
		else
		begin
			set @txt=@txt + 'Contact was attempted.' + char(13)

			if (select count(*) from ppd3..claimevents where claimid=@claimid and [type]=0 and Actioneddate is not null)<3
			begin
				-- Have NOT SPOKEN to PH so need to schedule another contact attempt, only where less than 3 attempts have been made
				-- CONFIRMED we schedule a new contact event if we don't speak to PH by JM 22/06/07
				insert into ppd3..claimevents (claimID,type,createdby,startdate)
				values (@claimID,0,@userID,dateadd(hour,2,getdate()))
			end
		end

		if @answered=0
		begin
			-- Insert of new contact event was here, but now moved up to insert if spoke1 or spoke2 not selected
			set @txt=@txt + 'The attempt was unsuccessful.' + char(13)
		end
		
		select @notereason=case when c.channel in ('NUIBRAD','AXA') then 92 else 11 end
		from ppd3..Claims c
		where c.claimid=@claimid
		
		exec ppd3..notecreate @claimID=@claimID,@note=@txt,@userID=@userID,@notetype=0,@notereason=@notereason

		-- Need to remove any scheduled letter if there exists a successful contact event
		if exists (
			select * from ppd3..claimevents ce
			where claimid=@claimID
			and exists (select * from ppd3..claimeventproperties p where p.eventid=ce.eventid and p.value in ('10','30','40') and p.name = 'contact')		-- There is a spoke-to event
		)
		begin
			delete from ppd3..claimevents
			where claimid=@claimID and type between 1 and 3 and actioneddate is null

			insert into ppd3..[log] (claimID,userID,type,[text])
			values (@claimID,@userID,'270','Successful contact, ICL Cancelled')
		end
		
	commit tran

GO
