SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[FIS_Process_CardErrors]
AS

begin tran

	insert into FisExceptions (RECID, ErrorMessage, CardID, CreatedBy)
	select distinct RecId, [Message], t.CardID, 'sys.etl'
	from FISCardErrorsLoad l
	join Transactions t on t.ID=l.RecId
	where Processed=0
	
	update t 
	set t.status=-1, t.AlteredBy='sys.etl', t.AlteredDate=getdate()
	from FISCardErrorsLoad l
	join Transactions t on t.ID=l.RecId
	where Processed=0
	
	update FISCardErrorsLoad set Processed=1, AlteredBy='sys.etl', AlteredDate=getdate()
	where Processed=0
	
	
	
commit
GO
