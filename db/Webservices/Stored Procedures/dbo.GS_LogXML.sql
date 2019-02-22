SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GS_LogXML]
@ClaimID int,
@Sender tinyint,
-- 0 = PowerPlay
-- 1 = Goldsmiths
@SendStatus tinyint,
-- 0 = Success
-- 1 = Failure
@MsgType tinyint,
-- 0 = Instruction
-- 1 = Event
-- 2 = Note
-- 3 = Item

-- 4 = quote

-- ideally 0=Quote 1= Order

@XML varchar(8000)
AS
/*
<Notation>
	<Name>gs_LogXML</Name>
	<CreatedBy>Mark Perry</CreatedBy>
	<CreateDate>20060512</CreateDate>
	<Referenced>
		<asp>Webservice</asp>
	</Referenced>
	<Overview>Called from Goldsmiths web service, logs XML to DB</Overview>
	<Changes>
		<Change>
			<User>RB</User>
			<Date>20060517</Date>
			<Comment>Added extra column - SendStatus</Comment>
		</Change>
	</Changes>
</Notation>
*/

declare @error varchar(200)
insert into Goldsmiths_Log (Claimid, Sender, SendStatus, MsgType, [XML])
select @ClaimID, @Sender, @SendStatus, @MsgType, @XML

-- Buggy as hell, but yeeeeha!
update ppd3.dbo.GoldsmithsMsgQOutgoing
set DateSent=getdate()
where ClaimID=@claimid
and @xml like 'Error: ReceiveInstruction found a duplicate claim%'

if left(@XML,5)='Error' and @@rowcount=0
begin
		set @error='Error in Goldsmiths WS Send: '+ left(@XML,200)
		exec ppd3.dbo.SendMail @Recipient = 'itsupport@bevalued.co.uk',
		    @SenderEmail = 'noreply@bevalued.co.uk', 
		    @SenderName = 'GS WS Error',
		    @Subject = 'Error', 
		    @Body = @error, 
		    @Bcc = '',
		    @r2 = '',
		    @r3 = '',
		    @r4 = ''	    
end
GO
