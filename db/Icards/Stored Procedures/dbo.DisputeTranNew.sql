SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[DisputeTranNew]
@iCardsID varchar(50),
@cardID int,
@OnTSYS int,
@TSYSid int,
@TranDate varchar(10),
@TranTime varchar(5),
@TranRetailer varchar(50),
@Reason int,
@Possession tinyint,
@Access tinyint,
@AlsoAccess varchar(50),
@AdditionalInfo varchar(8000),
@userid varchar(20)

AS

set nocount on
set dateformat dmy
set transaction isolation level read uncommitted
/*
<SP>
	<Name>DisputeTranNew</Name>
	<CreatedBy>Gary</CreatedBy>
	<CreateDate>20060523</CreateDate>
	<Referenced>
		<asp>iCardsDisputeTrans.asp</asp>
	</Referenced>
	<Overview>Saves details of a disputed transaction to the DB</Overview>
	<Changes>		
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/

BEGIN TRAN 

	insert into DisputedTransactions (iCardsID, CardID, OnTSYS, TSYSid, TranDate, TranRetailer, Reason, Possession, Access, AlsoAccess, AdditionalInfo, CreatedBy, CreateDate)
	select right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1)), @CardID, @OnTSYS, @TSYSid, @TranDate + ' ' + @TranTime, @TranRetailer, @Reason, @Possession, @Access, @AlsoAccess, @AdditionalInfo, @userid, getdate()
	from policies p
	join card_companies cc on cc.ID=.p.companyID
	where p.iCardsID = right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1))

	-- Log the event
	insert into [Log] (iCardsID, CreateDate, UserID,Type,[Text]) 
	VALUES (@iCardsID, getdate(), @userid, '25', 'Card ('+cast(@CardID AS varchar)+'): Reported a Disputed Transaction on '+@TranDate + ' at ' + @TranTime+' with '+@TranRetailer+' (TSYS ID: '+cast(@TSYSid AS varchar)+')')

	--Sends an email to NU to investigate the Lost/Stolen Card
	EXEC DisputeTranSendEmail @CardID

COMMIT

set transaction isolation level read committed


GO
