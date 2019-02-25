SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[FIS_ExportBalanceAdjustments]
@batchref varchar(50)
AS
SET NOCOUNT ON

select '<?xml version = "1.0"?>
<BALADJ>'
union all
select '
	<ADJUSTMENT> 
		<INSTCODE>AVI</INSTCODE> 
		<CARDID>'+d.CardId+'</CARDID>
		<CURRCODE>GBP</CURRCODE> 
		<AMTADJUSTMENT>'+d.Amount +'</AMTADJUSTMENT> 
		<DEBORCRED>'+d.AmountType+'</DEBORCRED> 
		<FORCEPOST>0</FORCEPOST> 
		<EXTCODE>'+d.RecId+'</EXTCODE> 
		<DESCRIPTION>'+ d.TranDesc+'</DESCRIPTION> 
	</ADJUSTMENT>'
from FIS_Data d 
where d.[Type]='B' 
and d.InvoiceBatchNo=@batchref
union all
select '</BALADJ>'
GO
