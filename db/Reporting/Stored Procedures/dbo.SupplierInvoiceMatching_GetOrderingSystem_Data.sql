SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SupplierInvoiceMatching_GetOrderingSystem_Data]
@ReportNo int,
@UserId UserID='sys'
as
set nocount on

insert into SupplierInvoicingAggregates (ReportNo,DID,Total, [Status],PartCancelled, Commodity, Channel, OriginatingSystem,MatchRef,CreatedBy)
select @ReportNo,od.DeliveryID, p.ProductPriceIncVat Total, od.[Status], 0 PartCancelled, isnull(od.Category,'Unknown') Commodity, 
	od.Channel, 'Ordering System' OriginatingSystem,x.OrderRef, @UserId
from SupplierInvoiceMatch m
join SN_Ordering_Orderingdelivery od on od.Id=m.DID
join SN_Ordering_TotalOrderPrice p on p.deliveryID=m.DID
outer apply dbo.SupplierInvoiceCleanData (null,od.OrderRef,null) as x
where m.ReportNo=@ReportNo

GO
