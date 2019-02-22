SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SupplierInvoiceMatching_GetCmsOrders_Data]
@ReportNo int,
@UserId UserID='sys'
as
set nocount on
insert into SupplierInvoicingAggregates (ReportNo,ClaimID, DID,Total, [Status],PartCancelled, Commodity, Channel, OriginatingSystem, Notes, SpExcess, Discount,MatchRef, CreatedBy)
select @ReportNo,sd.ClaimID, sd.DID, 
	case when sd.JSRInvoicePrice is null then
		isnull(sd.POTotal,0) * ((100.00 - isnull(g.RRPDiscount,0.00))/100)
	else sd.JSRInvoicePrice end POTotal,
	sd.[Status],
	case when exists (select * from SN_PPD3_SupplierdeliveryItems sdi where sdi.DID=sd.DID and sdi.[Status]=20) then 1 else 0 end PartCancelled,
	sd.Commodity, c.Channel, 'CMS' OriginatingSystem, sd.ExcessNotes, 
	case when sd.JSRInvoicePrice is null then isnull(sp.Excess,0) else 0 end spExcess, 
	case
		when sd.JSRInvoicePrice is null then isnull(g.RRPDiscount,0) 
	else
		case when sd.JSRInvoicePrice=0 then 0 else 100-(sd.JSRInvoicePrice/sd.POTotal*100) end
	end Discount, sd.MatchRef, @UserId
from SupplierInvoiceMatch m join SN_PPD3_SupplierDelivery sd on sd.DID=m.DID and sd.Distributor=m.SupplierID --------and sd.status!=10 --added for support 43770 to exclude cancelled DF's
join SN_PPD3_Claims c on c.ClaimID=m.ClaimID
left join SN_SupplierDelilveryItems_NonProducts np on np.did=m.DID
left join SN_PPD3_GenericRRPDiscount g on g.Channel=c.Channel and g.SupplierID=m.SupplierID and np.did=m.DID
left join SN_PPD3_SupplierPayments sp on sp.ClaimID=m.ClaimID and sp.FKID=sd.DID and sp.SendMethod='DF' and sp.SupplierCollectsExcess=3
where m.ReportNo=@ReportNo

GO
