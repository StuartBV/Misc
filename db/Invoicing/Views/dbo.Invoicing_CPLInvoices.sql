SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Invoicing_CPLInvoices] as

select o.[id] InvoiceNo,o.DeliveryId,o.CreateDate as InvoiceSent,
	isnull(oc.PriceNet,0)+isnull(i.PriceNet,0)+isnull(ic.PriceNet,0) NetTotal,
	isnull(oc.PriceGross,0)+isnull(i.PriceGross,0)+isnull(ic.PriceGross,0) Total,
	(isnull(oc.PriceGross,0)+isnull(i.PriceGross,0)+isnull(ic.PriceGross,0) ) - (isnull(oc.PriceNet,0)+isnull(i.PriceNet,0)+isnull(ic.PriceNet,0))  VatAmount
from  Invoicing_Orders o
join Invoicing_Items_totals i on i.DeliveryId=o.DeliveryId
left join dbo.Invoicing_Order_Charges_totals oc on oc.DeliveryId=o.DeliveryId
left join Invoicing_ItemCharges_totals ic on ic.DeliveryId=o.DeliveryId

/*
select o.[id] InvoiceNo,o.DeliveryId,o.CreateDate as InvoiceSent,
	sum(isnull(oc.PriceNet,0)+isnull(i.PriceNet,0)+isnull(ic.PriceNet,0)) NetTotal,
	sum(isnull(oc.PriceGross,0)+isnull(i.PriceGross,0)+isnull(ic.PriceGross,0)) Total,
	sum(isnull(oc.PriceGross,0)+isnull(i.PriceGross,0)+isnull(ic.PriceGross,0)) - sum(isnull(oc.PriceNet,0)+isnull(i.PriceNet,0)+isnull(ic.PriceNet,0)) VatAmount
from  Invoicing_Orders o
join Invoicing_Items i on i.orderid=o.[id]
left join dbo.Invoicing_Order_Charges oc on oc.InvoiceId=i.InvoiceId
left join Invoicing_ItemCharges ic on ic.ItemId=i.ItemId 
group by o.[id],o.[DeliveryId],o.CreateDate

*/
GO
