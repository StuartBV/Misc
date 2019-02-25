SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[iCardsListDisputedTransactions]
@CardID int

AS

SELECT	
	TSYSid,
	convert(char(10),TranDate,103) as TranDate,
	TranRetailer,
	sys.description as Reason,
	Possession,
	Access,
	AlsoAccess,
	convert(char(10),CreateDate,103)+' '+convert(char(5),CreateDate,14) as CreateDate
from DisputedTransactions dt
left join syslookup sys ON sys.code=dt.reason and sys.tablename='DisputeReason'
where CardID=@CardID
order by createdate desc
GO
