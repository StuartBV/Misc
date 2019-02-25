SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[iCardsStartNewUpdate4]
@iCardsID varchar(50),
@cardtype varchar(20),
@nameoncard varchar(19),
@value money = 0,
@userid varchar(20),
@reissue bit,
@originalref varchar(50)=null
as

set transaction isolation level read uncommitted
/*
<SP>
	<Name>iCardsStartNewUpdate5</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060510</CreateDate>
	<Referenced>
		<asp>iCardsStartNewUpdate.asp</asp>
	</Referenced>
	<Overview>Called from iCardsStartNewUpdate.asp to auto save new policy creation on iCardsStartNew.asp</Overview>
	<Changes>		
		<Change>
			<User>Gary</User>
			<Date>20060511</Date>
			<Comment>Added use of alteredby and altereddate, also amended to update tables not view</Comment>
		</Change>
	</Changes>
</SP>
*/

-- Updates the cards Table
update C set
cardtype = @cardtype,
nameoncard = @nameoncard,
alteredby=@userid,
altereddate=getdate(),
Reissue=@reissue,
OriginalRef=@originalref
from cards c
join policies p on p.customerID=c.customerID
join card_companies cc on cc.ID=p.companyID and cc.id=2
where p.iCardsID = cast(replace(@iCardsID,cc.ClaimNoPrefix,'') as int)

-- Updates the card_values Table
update t set
cardvalue = @value,
type='M',
status=1,
authrequirement=dbo.AuthRequirement(cu.postcode,t.id,@value),
--authrequirement=case when @value>10000 then 2 
--					 when left(cu.postcode,2) in ('BN','TN') OR right(t.ID,1)=0 OR right(t.ID,1)=5 then 3 
--					 when @value between 1500 and 10000 then 1 
--					 else 0 end,
alteredby=@userid,
altereddate=getdate()
from transactions t
join cards c on c.ID=t.cardID
join customers cu on cu.ID=c.customerID
join policies p on p.customerID=c.customerID
join card_companies cc on cc.ID=p.companyID and cc.id=2
where p.iCardsID = cast(replace(@iCardsID,cc.ClaimNoPrefix,'') as int)
--and t.status=1

set transaction isolation level read committed

GO
