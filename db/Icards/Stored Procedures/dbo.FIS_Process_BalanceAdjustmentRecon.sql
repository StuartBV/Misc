SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[FIS_Process_BalanceAdjustmentRecon]
AS
SET NOCOUNT ON

begin tran

	update t set t.status=2, t.AlteredBy='sys.etl', t.AlteredDate=getdate()
	from FISCardAdjustmentsLoad l
	join Transactions t on t.ID=l.RecId
	where Processed=0
	
	update FISCardAdjustmentsLoad set Processed=1, AlteredBy='sys.etl', AlteredDate=getdate()
	where Processed=0
	
commit
GO
