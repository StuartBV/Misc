SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[LostStolenCardNew]
@iCardsID varchar(50),
@cardID int,
@Type int,
@Date varchar(10),
@CrimeRef varchar(20)=null,
@LastTranDate varchar(10),
@LastTranTime varchar(5),
@LastTranRetailer varchar(50),
@TSYSid int,
@Used tinyint,
@AdditionalInfo varchar(8000),
@userid varchar(20)

AS

set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
/*
<SP>
	<Name>LostStolenCardNew</Name>
	<CreatedBy>Gary</CreatedBy>
	<CreateDate>20060522</CreateDate>
	<Referenced>
		<asp>iCardsLost.asp</asp>
	</Referenced>
	<Overview>Saves details of a newly report Lost/Stolen cards to the DB</Overview>
	<Changes>		
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/

begin tran
	-- Adds details to the LostStolenCards Table
	insert into LostStolenCards (iCardsID, CardID, Type, [Date], CrimeRef, LastTranDate, LastTranRetailer, TSYSid, UsedAfterLastTran, AdditionalInfo, CreatedBy, CreateDate)
	select right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1)), @cardID, @Type, @Date, @CrimeRef, @LastTranDate + ' ' + @LastTranTime, @LastTranRetailer, @TSYSid, @Used, @AdditionalInfo, @userid, getdate()
	from policies p
	join card_companies cc on cc.ID=.p.companyID
	where p.iCardsID = right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1))
	
	-- Adds a row to the card actions table to indicate that card has been reported lost or stolen
	insert into transactions (cardID, cardvalue, type, status, authrequirement, createdate, createdby)
	select ca.ID, 0, 'Z', 0, 0, getdate(), @userid
	from policies p
	join customers c on c.ID=p.customerID
	join cards ca on ca.customerID=c.ID
	join card_companies cc on cc.ID=.p.companyID
	where p.iCardsID = right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1)) and ca.ID=@cardID

	-- Log the event
	insert into [Log] (iCardsID, CreateDate, UserID,Type,[Text]) 
	VALUES (@iCardsID, getdate(), @userid, '24', 'Card ('+cast(@CardID AS varchar)+'): Reported '+case WHEN @type=1 THEN 'Lost' ELSE 'Stolen' END +' as of '+ @Date)

	--Sends an email to NU to investigate the Lost/Stolen Card
	EXEC LostStolenCardSendEmail @cardID
	
	update dbo.PolicyDetails
	set Status=case when AuthRequirement>0 then 0 else 1 end
	where icardsid=@iCardsID

commit tran

set transaction isolation level read committed


GO
