SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO


CREATE PROCEDURE [dbo].[RedemptionGet] 
@RedemptionID int
AS

set transaction isolation level read uncommitted

SELECT 
	r.CardID,
	r.CashSettled,
	r.CardActivated,
	convert(char(10),r.CardActivatedDate,103) CardActivatedDate,
	r.CurrentCardValue,
	r.LastTransactionLocation,
	r.LastTransactionDate,
	r.AdditionalInfo,
	r.createdate,
	r.CardNumber,
	r.Redeemed,
	r.RedeemedDate,
	r.CardBlockedonTsys,
	r.CardBlockedDate,
	r.LastTransactionLocation,
	r.lasttransactionDate,
	c.FirstName,c.LastName,c.Phone
from Redemptions r  
join customers c  on c.IcardsID = r.iCardsID
where r.ID=@RedemptionID

set transaction isolation level read committed


GO
