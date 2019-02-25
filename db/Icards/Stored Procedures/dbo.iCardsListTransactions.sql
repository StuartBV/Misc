SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[iCardsListTransactions]
@CardID int

AS
/*
<SP>
	<Name>iCardsListTransactions</Name>
	<CreatedBy>Gary</CreatedBy>
	<CreateDate>20060515</CreateDate>
	<Referenced>
		<asp>iCardsTransactions.asp</asp>
	</Referenced>
	<Overview>Lists all transactions for a specified card</Overview>
	<Changes>		
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
set dateformat dmy

declare @Supplierslist varchar(100)
select @supplierslist = coalesce(@supplierslist,'') + isnull(cast(ts.supplierid as varchar),'')+ ','
from transactions t
left join transactionsuppliers ts on ts.transactionid=t.id
where t.cardid=@cardid

select cv.cardid, 
	cv.cardvalue,  
	isnull(sys.extracode,'ERROR - Inform IT') as TransType, 
	isnull(status.[description],'ERROR - Inform IT') as Status,
	isnull(sysa.[description],'ERROR - Inform IT') as AuthRequirement,
	cv.BatchFileUploaded, 
	cv.AuthBy, 
	convert(char(10),cv.AuthDate,103)+' '+convert(char(5),cv.AuthDate,14) AuthDate,
	convert(char(10),cv.createdate,103)+' '+convert(char(5),cv.createdate,14) createdate,
	convert(char(10),InvoicedDate,103)+' '+convert(char(5),InvoicedDate,14) InvoicedDate,
	cv.createdby,
	@Supplierslist SuppliersList,
	case when cv.origValue=ts.rrp then 1 else 0 end FullSupplierSettlement,
	isnull(c.cardtype,-1) CardType
from transactions cv
left join cards c on c.id=cv.CardID
left join syslookup sys ON sys.code=cv.type and sys.tablename='CardActionType'
left join syslookup sysa ON sysa.code=cv.AuthRequirement and sysa.tablename='CardTransactionAuthorisation'
left join syslookup status ON status.code=cv.status and status.tablename='CardTransactionStatus'
left join transactionsuppliers ts on ts.transactionid=cv.ID
--where CardID=30
where CardID=@CardID
order by cv.createdate desc

select count(*)
from transactions 
where CardID=@CardID
AND status>1
GO
