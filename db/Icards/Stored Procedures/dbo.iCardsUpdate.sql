SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[iCardsUpdate]
@iCardsID varchar(50),
@title varchar(20),
@firstname varchar(50),
@lastname varchar(50),
@address1 varchar(50),
@address2 varchar(50),
@town varchar(50),
@county varchar(50),
@postcode varchar(50),
@phone varchar(50),
@userid varchar(20)
as
set transaction isolation level read uncommitted

update c set
title = @title,
firstname = @firstname,
lastname = @lastname,
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
join card_companies cc on cc.ID=.p.companyID
where p.iCardsID = right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1))

-- Update the AuthRequirement
update t
set authrequirement=case when left(@postcode,2) in ('BN','TN') OR right(t.ID,1)=0 then 3 else
		       case when t.cardvalue between 2500 and 10000 then 1 else
		       case when t.cardvalue>10000 then 2 else 0 end 
		       end
		      end
from transactions t 
join cards c on c.ID=t.CardID
join policies p on p.customerID=c.customerID
join card_companies cc on cc.ID=.p.companyID
where p.iCardsID = right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1))
and t.status=0

set transaction isolation level read committed


GO
