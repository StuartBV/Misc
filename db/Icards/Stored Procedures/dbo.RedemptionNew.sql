SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO


CREATE procedure [dbo].[RedemptionNew]
@iCardsID varchar(50),
@cardID int,
@Cashsettled tinyint,
@CardActivated tinyint,
@CardActivatedDate datetime,
@CurrentCardValue money,
@AdditionalInfo varchar(8000),
@LastTransactionLocation varchar(100),
@LastTransactionDate datetime,
@CardNumber varchar(20),
@CardBlockedonTsys bit,
@CardBlockedDate varchar(20),
@userid varchar(20)

AS

set nocount on
set dateformat dmy
Set @CardBlockedDate = getdate()
if @CardActivatedDate = ''
Begin
	set @CardActivatedDate = NULL
end
if @LastTransactionDate = ''
Begin
	set @LastTransactionDate = NULL
end

/*
<SP>
	<Name>RedemptionNew</Name>
	<CreatedBy>Gary</CreatedBy>
	<CreateDate>20060602</CreateDate>
	<Referenced>
		<asp>iCardsRedemptions.asp</asp>
	</Referenced>
	<Overview>Saves details of a redemption to the DB</Overview>
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

	insert into Redemptions (iCardsID, CardID,CashSettled, CardActivated, CardActivatedDate, CurrentCardValue,LastTransactionLocation,LastTransactionDate,AdditionalInfo,CardNumber,CardBlockedonTsys,CardBlockedDate, CreatedBy, CreateDate)
	select right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1)), @CardID,@Cashsettled ,@CardActivated, @CardActivatedDate, @CurrentCardValue,@LastTransactionLocation,@LastTransactionDate,@AdditionalInfo,@CardNumber,@CardBlockedonTsys,@CardBlockedDate,@userid, getdate()
	from policies p
	join card_companies cc(nolock) on cc.ID=.p.companyID
	where p.iCardsID = right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1))

	-- Log the event
	insert into [Log] (iCardsID, CreateDate, UserID,Type,[Text]) 
	VALUES (@iCardsID, getdate(), @userid, '26', 'Card ('+cast(@CardID AS varchar)+'): Redemtion request initiated')

COMMIT
GO
