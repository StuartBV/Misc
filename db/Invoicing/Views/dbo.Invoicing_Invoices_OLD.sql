SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[Invoicing_Invoices_OLD] as

select 
	o.channel + 'V2' [AccountRef], 
	o.OrderDate [OrderSentDate],
	o.createdate [InvoiceCreateDate],
	isnull(nullif(o.Reference,''),'Not entered') [Reference],
	o.[Id] [InvoiceNo],
	o.DeliveryId,
	x.PriceNet, x.PriceGross, x.PriceGross-x.PriceNet [VatAmount],
	isnull(cu.Surname,'') Surname,	isnull(ad.Postcode,'') Postcode,
	o.SupplierName,
	x.DeliveryCostNet, x.InstallCostNet, x.DisposalCostNet, x.ProductPriceNet,x.ProductPriceGross,
	x.DeliveryCostGross, x.InstallCostGross, x.DisposalCostGross,
	o.SourceType, o.SourceKey,
	o.SageSentDate, o.BordereauSentDate, o.BordereauNo, o.Channel,
	x.vatrate
from Invoicing_Orders o
join (
		select i.OrderID,
			sum(isnull(i.PriceNet,0))  [ProductPriceNet],
			sum(isnull(i.PriceGross,0))  [ProductPriceGross],
			sum(isnull(oc.PriceNet,0)+isnull(i.PriceNet,0)+isnull(ic.PriceNet,0)) [PriceNet],
			sum(isnull(oc.PriceGross,0)+isnull(i.PriceGross,0)+isnull(ic.PriceGross,0)) [PriceGross],
			sum(case when ic.[type]=1 then ic.pricenet else 0 end + isnull(oc.PriceNet,0)) [DeliveryCostNet],
			sum(case when ic.[type]=2 then ic.pricenet else 0 end) [InstallCostNet],
			sum(case when ic.[type]=3 then ic.pricenet else 0 end) [DisposalCostNet],
			sum(case when ic.[type]=1 then ic.pricegross else 0 end + isnull(oc.PriceGross,0)) [DeliveryCostGross],
			sum(case when ic.[type]=2 then ic.pricegross else 0 end) [InstallCostGross],
			sum(case when ic.[type]=3 then ic.pricegross else 0 end) [DisposalCostGross],
			i.vatrate
		from Invoicing_Items i
		left join dbo.Invoicing_Order_Charges oc on oc.InvoiceId=i.InvoiceId
		left join Invoicing_ItemCharges ic on ic.ItemId=i.ItemId 
		group by i.OrderId,i.vatrate
)x  on x.OrderID=o.[id]
left join dbo.Invoicing_Customer cu on cu.[id]=o.CustomerId
left join dbo.Invoicing_Address ad on o.DeliveryId=ad.DeliveryId
left join ppd3.dbo.ValidationSuppliers vs on vs.type=o.Channel and vs.SupplierID=o.SupplierId
where o.Channel is not null and vs.SupplierID is null
GO
