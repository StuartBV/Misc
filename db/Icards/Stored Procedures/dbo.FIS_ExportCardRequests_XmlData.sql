SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[FIS_ExportCardRequests_XmlData]
@batchref varchar(50)
as

select '<?xml version = "1.0"?>
	<CRDREQ>'
union all
select '
	<CARD> 
		<RECID>'+d.Recid+'</RECID>
		<CARDID>'+d.CardId+'</CARDID>
		<ACTION>'+d.Action+'</ACTION>
		<ACCESSCODE>'+dbo.GetAccessCode(d.InsurancePolicyNo)+'</ACCESSCODE>
		<INSTCODE>AVI</INSTCODE> 
		<PROGRAMID>AVIVA1</PROGRAMID> 
		<PARTICIPANTID>'+d.ParticipantId+'</PARTICIPANTID>
		<ACCNO>'+d.AccountNo+'</ACCNO>
		<DESIGNREF>AVI1</DESIGNREF>
		<TITLE>'+d.Title+'</TITLE> 
		<LASTNAME>'+replace(d.LastName,'&','and')+'</LASTNAME> 
		<FIRSTNAME>'+replace(d.FirstName,'&','and')+'</FIRSTNAME> 
		<ADDRL1>'+d.Address1+'</ADDRL1> 
		<CITY>'+d.City+'</CITY> 
		<COUNTY></COUNTY>
		<POSTCODE>'+d.Postcode+'</POSTCODE>
		<COUNTRY>826</COUNTRY> 
		<TEL>'+d.Tel+'</TEL> 
		<CURRCODE>GBP</CURRCODE> 
		<CRDPRODUCT>AVI1</CRDPRODUCT> 
		<AMTLOAD>'+d.Amount+'</AMTLOAD>
		<LANG>1</LANG>
		<CARDNAME>'+replace(d.CardName,'&','and')+'</CARDNAME>
		<PRODUCEPIN>1</PRODUCEPIN> 
		<DLVMETHOD>1</DLVMETHOD>
		<STATCODE>02</STATCODE>
	</CARD>'
from FIS_Data d
where d.[Type] in ('M','C')
and (d.InvoiceBatchNo=@batchref or d.InvoiceBatchNo='reissue')
union all
select '
	<CARD> 
		<RECID>'+d.RecId+'</RECID> 
		<ACTION>'+d.Action+'</ACTION>
		<CARDID>'+d.CardId+'</CARDID>
		<ACCESSCODE>'+cast(d.ICardsID as varchar)+'</ACCESSCODE>
		<INSTCODE>AVI</INSTCODE> 
		<PROGRAMID>AVIVA1</PROGRAMID> 
		<PARTICIPANTID>9339</PARTICIPANTID>
		<ACCNO>FIS9339</ACCNO>
		<CURRCODE>GBP</CURRCODE> 
		<CRDPRODUCT>AVI1</CRDPRODUCT> 
		<LANG>1</LANG>
	</CARD>'
from FIS_Data d
where d.[Type] in ('R','Z')
and (d.InvoiceBatchNo=@batchref or d.InvoiceBatchNo='reissue')
union all
select '</CRDREQ>'
GO
