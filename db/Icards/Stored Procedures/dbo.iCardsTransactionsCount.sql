SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[iCardsTransactionsCount] 
@CardID int
AS

-- Checks the number of transactions a card has had batchfiled
select count(*)
from transactions 
where CardID=@CardID
AND status>1
GO
