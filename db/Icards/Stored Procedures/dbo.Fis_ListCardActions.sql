SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Fis_ListCardActions]
@CardID int

AS

set dateformat dmy

select distinct
	cv.id [transactionID],
	cv.cardid, 
	cv.cardvalue,  
	isnull(sysf.description,'ERROR - Inform IT') as TransType, 
	isnull(status.[description],'ERROR - Inform IT') as Status,
	isnull(sysa.[description],'ERROR - Inform IT') as AuthRequirement,
	cv.BatchFileUploaded, 
	cv.AuthBy, 
	convert(char(10),cv.AuthDate,103)+' '+convert(char(5),cv.AuthDate,14) AuthDate,
	convert(char(10),cv.createdate,103)+' '+convert(char(5),cv.createdate,14) createdate,
	convert(char(10),InvoicedDate,103)+' '+convert(char(5),InvoicedDate,14) InvoicedDate,
	cv.createdby,
	isnull(c.cardtype,-1) CardType,
	case when scl.CardID is null and cv.status=1 then 0 -- waiting upload
		 when scl.CardID is null and cv.status=2 then 1 --waiting response
		 else 2 --received response
		 end [FisResponse],
	dbo.FisResponseConCat(cv.id) [FisResponseMsg],
	case when fe.RECID is null then 0 else 1 end [FisException],
	case when fe.ErrorMessage is null then '' else '<b>FIS found the following issue: </b>'+fe.ErrorMessage end [FisExceptionMsg]
from transactions cv
left join cards c on c.id=cv.CardID
left join syslookup sys ON sys.code=cv.type and sys.tablename='CardActionType'
left join dbo.SysLookup sysm on sys.code=sysm.code and sysm.TableName='FISActionCodeMapping'
left join dbo.SysLookup sysf on sysf.code=sysm.ExtraCode and sysf.TableName='FISActionCode'
left join syslookup sysa ON sysa.code=cv.AuthRequirement and sysa.tablename='CardTransactionAuthorisation'
left join syslookup status ON status.code=cv.status and status.tablename='CardTransactionStatus'
left join dbo.SupplierCardLog scl on scl.TransactionID=cv.ID
left join syslookup scll ON scll.code=scl.StatCode and scll.tablename='FisStatusCode'
left join dbo.FisExceptions fe on fe.RECID=cv.id and fe.CardID=cv.CardID and fe.Actioned=0
where cv.CardID=@CardID
order by createdate desc


GO
