SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SupplierInvoiceMatching_MatchTotals_new]
@ReportNo int,
@from datetime,
@customDiscount decimal(8,3)=1	-- Exists to support Amazon reporting
as
set nocount on

declare @threshold smallmoney
select @threshold=cast(isnull(code,0) as smallmoney) from SN_PPD3_SysLookup where tablename='InvoiceMatchVarianceThreshold'

update r set
	r.channel=coalesce(sd.channel,c.channel,'Unknown'),
	r.commodity=isnull(sd.commodity,'Not Found'),
	r.OriginatingSystem=isnull(sd.OriginatingSystem,''),
	r.Notes=left(sd.Notes,200),
	r.OrderTotal=round(isnull(sd.total*@customDiscount,0)-isnull(sd.spExcess,0),2), 
	r.variance=case when abs(round((sd.total*@customDiscount)-isnull(sd.spExcess,0),2)-r.invoicetotal) between 0.001 and @threshold then '(' + cast(cast(round(((sd.total*@customDiscount)-isnull(sd.spExcess,0))-r.invoicetotal,2) as decimal(8,2)) as varchar) + ')'
		else cast(cast(round((sd.total*@customDiscount)-isnull(sd.spExcess,0),2)-r.invoicetotal as decimal(8,2)) as varchar) end,
	discount=isnull(sd.Discount,0),
	MatchCode =
	case 
		when exists (select * from SN_PPD3_SupplierInvoices si where si.InvoiceDate<@from and si.SupplierID=r.supplierid and si.POREF=r.supplierRef) then 'Prev Duplicate' -- SupplierID used for better index useage
		when duplicate.supplierRef is not null then 'Duplicate (' +  cast(duplicate.qty as varchar(2)) + ')' 
		when vs.supplierid is not null then 'Supplier invoices direct!'	
		when sd.did is null or sd.MatchRef!=r.SupplierRef then 'Not Matched'
		when sd.PartCancelled=1 then 'Part Cancelled'
		when sd.[status]=5 then 'No Dispatch'
		when sd.[status]=10 then 'DF cancelled'
		when r.invoicetotal<0 then 'Credit'
		when round(((sd.total*@customDiscount)-isnull(sd.spExcess,0))-r.invoicetotal,2)<@threshold then 'Matched'
	else 'Part Matched' end
from SupplierInvoiceMatch r
left join SupplierInvoicingAggregates sd on sd.ReportNo=r.ReportNo and sd.did=r.DID and sd.ClaimID=r.ClaimID
left join SN_PPD3_claims c on c.claimid=r.claimid 
left join SN_PPD3_ValidationSuppliers vs on vs.[type]=c.channel and vs.SupplierID=r.SupplierID
left join (
	select SupplierRef, min(id) ID, count(*) Qty
	from SupplierInvoiceMatch
	where ReportNo=@ReportNo
	group by SupplierRef
	having count(*)>1
) duplicate on duplicate.SupplierRef=r.SupplierRef and r.ID>duplicate.ID
--left join SN_PPD3_SupplierPayments sp on c.claimid=sp.claimid and sp.SuppliercollectsExcess=3
where r.ReportNo=@ReportNo
GO
