SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[FIS_Process_CardResponse]
AS

begin tran

	--Update cardId and pan
	update c set Pan=l.Pan, SupplierCardId=l.CardId
	from Cards c
	join Transactions t on t.CardID=c.id
	join (
		select distinct RecId, Pan, CardId
		from FISCardResponseLoad l 
		where l.processed=0
	)l on l.RecId=t.ID
	and (
		c.Pan!=l.Pan
		OR c.SupplierCardId=l.CardId
	)

	--Insert into SupplierCardLog
	insert into SupplierCardLog (TransactionID, PAN, CardID, StatCode, 
						CardEvent, ExpiryDate, CreatedBy)
	select RecId, Pan, CardId, StatCode, 
						CardEvent, ExpiryDate,'sys.etl'
	from FISCardResponseLoad l 
	where l.processed=0

	-- Update processed flag
	update FISCardResponseLoad set Processed=1, AlteredBy='sys.etl',AlteredDate=getdate()
	where processed=0
	
commit tran
GO
