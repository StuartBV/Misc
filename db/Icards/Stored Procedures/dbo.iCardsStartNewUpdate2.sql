SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[iCardsStartNewUpdate2]
@iCardsID varchar(50),
@title varchar(20),
@firstname varchar(50),
@lastname varchar(50),
@userID varchar(20)
as
set transaction isolation level read uncommitted
/*
<SP>
	<Name>iCardsStartNewUpdate3</Name>
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
title = @title,
firstname = @firstname,
lastname = @lastname,
alteredby = @userid,
altereddate = getdate()
from customers c
join policies p on p.customerID=c.ID
join card_companies cc on cc.ID=p.companyID and cc.id=2
where p.iCardsID = cast(replace(@iCardsID,cc.ClaimNoPrefix,'') as int)

set transaction isolation level read committed


GO
