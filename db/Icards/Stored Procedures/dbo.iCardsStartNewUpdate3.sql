SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[iCardsStartNewUpdate3]
@iCardsID varchar(50),
@address1 varchar(50),
@address2 varchar(50),
@town varchar(50),
@county varchar(50),
@postcode varchar(50),
@phone varchar(50),
@userid varchar(20)
as
set transaction isolation level read uncommitted
/*
<SP>
	<Name>iCardsStartNewUpdate4</Name>
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
			<Comment>Added use of alteredby and altereddate, also amended to update table not view</Comment>
		</Change>
	</Changes>
</SP>
*/


update c set
address1 = @address1,
address2 = @address2,
town = @town,
county = @county,
postcode = @postcode,
phone = @phone,
alteredby= @userid,
altereddate=getdate()
from customers c
join policies p on p.customerID=c.ID
join card_companies cc on cc.ID=p.companyID and cc.id=2
where p.iCardsID = cast(replace(@iCardsID,cc.ClaimNoPrefix,'') as int)


-- Update the AuthRequirement
update t
set authrequirement=case when left(@postcode,2) in ('BN','TN') OR right(t.ID,1)=0 OR right(t.ID,1)=5 then 3 else
		       case when t.cardvalue between 1500 and 10000 then 1 else
		       case when t.cardvalue>10000 then 2 else 0 end 
		       end
		      end
from transactions t 
join cards c on c.ID=t.CardID
join policies p on p.customerID=c.customerID
join card_companies cc on cc.ID=p.companyID and cc.id=2
where p.iCardsID = cast(replace(@iCardsID,cc.ClaimNoPrefix,'') as int)
and t.status=0

set transaction isolation level read committed


GO
