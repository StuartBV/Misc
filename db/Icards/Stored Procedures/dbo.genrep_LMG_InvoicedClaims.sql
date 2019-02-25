SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[genrep_LMG_InvoicedClaims] 
@from varchar(10),
@to varchar(10),
@channel varchar(10)='',
@officegroupid int = 0
as
--UTC--
set dateformat dmy
set nocount on

declare @fd datetime, @td datetime
select @fd=cast(@from as datetime), @td=dateadd(mi,-1,dateadd(d,1,@to))

select c.ClaimID, c.insuranceclaimno InsuranceClaimNo, i.name InsuranceCompany,
	case when c.InsuranceCoID in (265,1054,1102,1110,1179) then 'HBOS' else  
		case when c.InsuranceCoID in (1180) then 'LTSB' else '' end
	end MIChannel,
	c.channel Channel,
	isnull(convert(char(10),c.createdate,103)+' '+convert(char(5),c.createdate,14),'') [Claim create date],
	isnull(d.name,'CancelFee') FulfilmentRoute,
	sum(case when ijv.SettlementRoute=p.prodid then 1 else 0 end ) NumValidations,
	isnull(p.make,'') Make,
	isnull(p.title,'') Model,
	isnull(p.format,'') Format,
	oi.invoiceprice - isnull(lmgxs.excess,0) InvoicePrice,
	cast( (oi.invoiceprice - isnull(lmgxs.excess,0)) / oi.VatRate  as decimal (8,2) )InvoicePriceNet,
	oi.VatAmount - isnull(lmgxs.excessvat,0) VatAmount,
	oi.Discount,
	oi.RRP,
	isnull(c.Excess,0) Excess,
	c.causeofclaim Peril,
	isnull(convert(char(10),c.InvoiceSentUTC,103)+' '+convert(char(5),c.InvoiceSentUTC,14),'') InvoiceSent,
	isnull(can.[description],'')  CancelReason,
	c.RAG RiskStatus,
	case when c.delegated=1 then 'Y' else 'N' end Delegated,
	offID.[description] Office
from claims c
left join insurancecos i on i.id=c.insurancecoID
join orderitems oi on oi.claimid=c.claimid and type='Q' and oi.[status] not in ('X','Damaged')
left join products p on p.prodid=oi.prodid
left join distributor d on d.id=p.distributor
left join SupplierPayments_ExcessForDeductedSettlements lmgxs on lmgxs.claimid=oi.ClaimID and oi.ProdID=lmgxs.prodid
left join ICE_Jewellery_Validations ijv on ijv.claimID=c.ClaimID
left join syslookup can on can.code=c.CancelCode and can.tablename='CancelReason'
left join syslookup offID on offID.code=c.OfficeID and offID.tablename='OfficeID'
where c.InvoiceSentUTC between @fd and @td
and (@channel='' or @channel=c.channel)
and (@officegroupid=0 or c.OfficeGroupID=@officegroupid)
and isnull(c.CancelCode,0)!=99
group by c.ClaimID,c.insuranceclaimno,i.name,c.InsuranceCoID,i.name,d.name,p.make,p.title,p.format,oi.invoiceprice,lmgxs.excess,lmgxs.excessvat,
oi.VatRate,oi.VatAmount,oi.Discount,oi.RRP,c.Excess,c.InvoiceSentUTC,can.[description],c.RAG,offID.[description],c.CauseofClaim,c.CreateDate,c.delegated
GO
